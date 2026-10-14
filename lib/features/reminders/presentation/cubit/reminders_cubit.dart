import 'dart:async';

import 'package:clock/clock.dart';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/app_clock.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/core/utils/streams.dart';
import 'package:daily_mate/features/reminders/domain/reminder.dart';
import 'package:daily_mate/features/reminders/domain/reminder_draft.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event.dart';
import 'package:daily_mate/features/reminders/domain/reminder_repository.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminders_cubit.freezed.dart';
part 'reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit(
    this._reminders,
    TaskRepository tasks,
    SettingsRepository settings,
    AppClock clock,
  ) : super(const RemindersState.loading()) {
    final taskAlerts = combineLatest2(
      switchMap(
        clock.watchToday(),
        (today) => tasks.watchTasks(
          TaskFilter(dueFrom: today, dueTo: addDays(today, taskWindowDays)),
        ),
      ),
      settings.watch(),
      (list, s) => (tasks: list, defaultMinutes: s.defaultReminderMinutes),
    );
    _subscription =
        combineLatest2(
          combineLatest2(
            _reminders.watchReminders(),
            _reminders.watchEvents(),
            (reminders, events) => (reminders: reminders, events: events),
          ),
          combineLatest2(
            taskAlerts,
            clock.watchNow(),
            (alerts, now) => (alerts: alerts, now: now),
          ),
          (a, b) => _build(
            a.reminders,
            a.events,
            b.alerts.tasks,
            b.alerts.defaultMinutes,
            b.now,
          ),
        ).listen(
          emit,
          onError: (Object error, StackTrace stack) {
            AppLogger.e('Reminders failed', error, stack);
            emit(const RemindersState.error("Couldn't load reminders."));
          },
        );
  }

  static const int taskWindowDays = 7;

  final ReminderRepository _reminders;
  late final StreamSubscription<RemindersState> _subscription;

  Future<int> createReminder(ReminderDraft draft) => _reminders.create(draft);

  Future<void> updateReminder(int id, ReminderDraft draft) =>
      _reminders.update(id, draft);

  Future<void> deleteReminder(int id) => _reminders.delete(id);

  Future<void> setEnabled(Reminder r, {required bool enabled}) =>
      _reminders.setEnabled(r.id, enabled: enabled);

  Future<void> markDone(Reminder r) => _reminders.markDone(r.id);

  Future<void> snooze(Reminder r, Duration duration) =>
      _reminders.snooze(r.id, clock.now().add(duration));

  RemindersState _build(
    List<Reminder> reminders,
    List<ReminderEvent> events,
    List<Task> tasks,
    int defaultMinutes,
    DateTime now,
  ) {
    DateTime nextOf(Reminder r) {
      final snooze = r.snoozedUntil;
      final next = r.nextOccurrence(now);
      if (snooze != null && snooze.isAfter(now)) {
        return next == null || snooze.isBefore(next) ? snooze : next;
      }
      return next ?? r.startAt;
    }

    final upcoming = [
      for (final r in reminders)
        if (r.isUpcoming(now)) (reminder: r, next: nextOf(r)),
    ]..sort((a, b) => a.next.compareTo(b.next));
    final taskAlerts = [
      for (final t in tasks)
        if (t.reminderAt(defaultMinutes: defaultMinutes) case final at?
            when at.isAfter(now))
          (task: t, at: at),
    ]..sort((a, b) => a.at.compareTo(b.at));

    return RemindersState.loaded(
      now: now,
      upcoming: upcoming,
      past: [
        for (final r in reminders)
          if (r.enabled && r.isPast(now) && !r.isUpcoming(now)) r,
      ],
      off: [
        for (final r in reminders)
          if (!r.enabled && r.completedAt == null) r,
      ],
      done: [
        for (final r in reminders)
          if (r.completedAt != null) r,
      ],
      taskAlerts: taskAlerts,
      history: events,
    );
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
