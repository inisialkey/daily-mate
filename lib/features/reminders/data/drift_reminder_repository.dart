import 'package:clock/clock.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/features/reminders/domain/reminder.dart';
import 'package:daily_mate/features/reminders/domain/reminder_draft.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event_kind.dart';
import 'package:daily_mate/features/reminders/domain/reminder_repository.dart';
import 'package:drift/drift.dart';

class DriftReminderRepository implements ReminderRepository {
  DriftReminderRepository(this._db);

  final AppDatabase _db;

  $RemindersTable get _r => _db.reminders;

  SimpleSelectStatement<$RemindersTable, ReminderRow> get _all =>
      _db.select(_r)..orderBy([
        (r) => OrderingTerm.asc(r.date),
        (r) => OrderingTerm.asc(r.minutes),
        (r) => OrderingTerm.asc(r.id),
      ]);

  @override
  Stream<List<Reminder>> watchReminders() =>
      _all.watch().map((rows) => rows.map(_toEntity).toList());

  @override
  Future<List<Reminder>> reminders() async =>
      (await _all.get()).map(_toEntity).toList();

  @override
  Future<Reminder?> reminder(int id) async {
    final row = await (_db.select(
      _r,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<int> create(ReminderDraft draft) {
    final d = draft.normalized();
    final now = clock.now();
    return _db
        .into(_r)
        .insert(
          _fields(d).copyWith(createdAt: Value(now), updatedAt: Value(now)),
        );
  }

  @override
  Future<void> update(int id, ReminderDraft draft) => _db.transaction(() async {
    final d = draft.normalized();
    final current = await reminder(id);
    if (current == null) return;
    final timingChanged =
        d.date != current.date ||
        d.minutes != current.minutes ||
        d.recurrence != current.recurrence;
    await _byId(id).write(
      _fields(d).copyWith(
        // New timing re-arms a finished one-time reminder.
        completedAt: timingChanged ? const Value(null) : const Value.absent(),
        snoozedUntil: timingChanged ? const Value(null) : const Value.absent(),
        updatedAt: Value(clock.now()),
      ),
    );
  });

  @override
  Future<void> delete(int id) =>
      (_db.delete(_r)..where((r) => r.id.equals(id))).go();

  @override
  Future<void> setEnabled(int id, {required bool enabled}) => _byId(id).write(
    RemindersCompanion(
      isEnabled: Value(enabled),
      snoozedUntil: const Value(null),
      updatedAt: Value(clock.now()),
    ),
  );

  @override
  Future<void> markDone(int id) => _db.transaction(() async {
    final current = await reminder(id);
    if (current == null) return;
    final now = clock.now();
    await _byId(id).write(
      RemindersCompanion(
        completedAt: current.isRecurring ? const Value.absent() : Value(now),
        snoozedUntil: const Value(null),
      ),
    );
    await logEvents([
      ReminderEvent(
        title: current.title,
        kind: ReminderEventKind.done,
        at: now,
        reminderId: id,
      ),
    ]);
  });

  @override
  Future<void> snooze(int id, DateTime until) => _db.transaction(() async {
    final current = await reminder(id);
    if (current == null) return;
    await _byId(id).write(RemindersCompanion(snoozedUntil: Value(until)));
    await logEvents([
      ReminderEvent(
        title: current.title,
        kind: ReminderEventKind.snoozed,
        at: clock.now(),
        reminderId: id,
      ),
    ]);
  });

  @override
  Stream<List<ReminderEvent>> watchEvents({int limit = 100}) =>
      (_db.select(_db.reminderEvents)
            ..orderBy([
              (e) => OrderingTerm.desc(e.occurredAt),
              (e) => OrderingTerm.desc(e.id),
            ])
            ..limit(limit))
          .map(
            (row) => ReminderEvent(
              id: row.id,
              title: row.title,
              kind: row.kind,
              at: row.occurredAt,
              reminderId: row.reminderId,
              taskId: row.taskId,
            ),
          )
          .watch();

  @override
  Future<void> logEvents(List<ReminderEvent> events) => _db.batch(
    (b) => b.insertAll(_db.reminderEvents, [
      for (final e in events)
        ReminderEventsCompanion.insert(
          title: e.title,
          kind: e.kind,
          occurredAt: e.at,
          reminderId: Value(e.reminderId),
          taskId: Value(e.taskId),
        ),
    ]),
  );

  UpdateStatement<$RemindersTable, ReminderRow> _byId(int id) =>
      _db.update(_r)..where((r) => r.id.equals(id));

  RemindersCompanion _fields(ReminderDraft d) {
    final rule = d.recurrence;
    return RemindersCompanion(
      title: Value(d.title),
      notes: Value(d.notes),
      date: Value(d.date),
      minutes: Value(d.minutes),
      recurrenceFrequency: Value(rule?.frequency),
      recurrenceInterval: Value(rule?.interval ?? 1),
      recurrenceWeekdays: Value(weekdaysToMask(rule?.weekdays ?? const {})),
      recurrenceUntil: Value(rule?.until),
      isEnabled: Value(d.enabled),
    );
  }

  Reminder _toEntity(ReminderRow row) {
    final frequency = row.recurrenceFrequency;
    return Reminder(
      id: row.id,
      title: row.title,
      notes: row.notes,
      date: row.date,
      minutes: row.minutes,
      recurrence: frequency == null
          ? null
          : RecurrenceRule(
              frequency: frequency,
              interval: row.recurrenceInterval,
              weekdays: weekdaysFromMask(row.recurrenceWeekdays),
              until: row.recurrenceUntil,
            ),
      enabled: row.isEnabled,
      snoozedUntil: row.snoozedUntil,
      completedAt: row.completedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
