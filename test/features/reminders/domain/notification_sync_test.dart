import 'package:clock/clock.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/features/reminders/data/drift_reminder_repository.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_sync.dart';
import 'package:daily_mate/features/reminders/domain/reminder_draft.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event_kind.dart';
import 'package:daily_mate/features/reminders/domain/reminder_notification_source.dart';
import 'package:daily_mate/features/reminders/domain/task_notification_source.dart';
import 'package:daily_mate/features/settings/data/drift_settings_repository.dart';
import 'package:daily_mate/features/tasks/data/drift_task_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_notification_scheduler.dart';
import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftReminderRepository reminders;
  late DriftTaskRepository tasks;
  late DriftSettingsRepository settings;
  late FakeNotificationScheduler os;

  final now = DateTime(2026, 10, 14, 8);
  final today = DateTime(2026, 10, 14);

  setUp(() {
    db = testDatabase();
    reminders = DriftReminderRepository(db);
    tasks = DriftTaskRepository(db);
    settings = DriftSettingsRepository(db);
    os = FakeNotificationScheduler();
  });
  tearDown(() => db.close());

  NotificationSync sync({int maxScheduled = 60}) => NotificationSync(
    scheduler: os,
    sources: [
      ReminderNotificationSource(reminders),
      TaskNotificationSource(tasks, settings),
    ],
    reminders: reminders,
    tasks: tasks,
    settings: settings,
    maxScheduled: maxScheduled,
  );

  Future<T> at<T>(DateTime time, Future<T> Function() body) =>
      withClock(Clock.fixed(time), body);

  Future<int> daily(String title, {int minutes = 9 * 60}) => reminders.create(
    ReminderDraft(
      title: title,
      date: today,
      minutes: minutes,
      recurrence: RecurrenceRule.daily,
    ),
  );

  test('schedules every planned alert and verifies macOS holds it', () async {
    await daily('Vitamins');
    await reminders.create(
      ReminderDraft(title: 'Call bank', date: today, minutes: 10 * 60),
    );

    final report = await at(now, () => sync().reconcile());

    // 14 days of the daily reminder + the one-time call.
    expect(report.planned, 15);
    expect(report.verified, 15);
    expect(report.allScheduled, isTrue);
    expect(report.nextAt, DateTime(2026, 10, 14, 9));
    expect(os.heldNotifications.first.title, 'Vitamins');
  });

  test('reconciling again changes nothing (no duplicates)', () async {
    await daily('Vitamins');
    final s = sync();
    await at(now, s.reconcile);
    os.clearCalls();

    final report = await at(now, s.reconcile);
    expect(os.scheduleCalls, isEmpty);
    expect(os.cancelCalls, isEmpty);
    expect(report.verified, report.planned);
  });

  test('editing a reminder replaces its alerts', () async {
    final id = await reminders.create(
      ReminderDraft(title: 'Meds', date: today, minutes: 9 * 60),
    );
    final s = sync();
    await at(now, s.reconcile);
    final before = os.held.keys.single;

    await reminders.update(
      id,
      ReminderDraft(title: 'Meds', date: today, minutes: 9 * 60 + 30),
    );
    await at(now, s.reconcile);

    expect(os.cancelCalls, [before]);
    expect(os.heldNotifications.single.at, DateTime(2026, 10, 14, 9, 30));
  });

  test('disabling, deleting and finishing remove pending alerts', () async {
    final a = await daily('A');
    final b = await daily('B', minutes: 10 * 60);
    final c = await reminders.create(
      ReminderDraft(title: 'C', date: today, minutes: 11 * 60),
    );
    final s = sync();
    await at(now, s.reconcile);

    await reminders.setEnabled(a, enabled: false);
    await reminders.delete(b);
    await at(now, () => reminders.markDone(c));
    final report = await at(now, s.reconcile);

    expect(report.planned, 0);
    expect(os.held, isEmpty);
  });

  test("requests that are not DailyMate's are never touched", () async {
    os.held[77] = 'someone-else';
    os.held[78] = null;
    await daily('Vitamins');
    await at(now, () => sync().reconcile());
    expect(os.held[77], 'someone-else');
    expect(os.held.containsKey(78), isTrue);
    expect(os.cancelCalls, isEmpty);
  });

  test('duplicate pending requests are cancelled', () async {
    await reminders.create(
      ReminderDraft(title: 'Once', date: today, minutes: 9 * 60),
    );
    final s = sync();
    await at(now, s.reconcile);
    final payload = os.held.values.single;
    os.held[999] = payload;

    final report = await at(now, s.reconcile);
    expect(os.held, hasLength(1));
    expect(report.verified, 1);
  });

  test('ids never collide with existing requests', () async {
    await reminders.create(
      ReminderDraft(title: 'Once', date: today, minutes: 9 * 60),
    );
    final s = sync();
    await at(now, s.reconcile);
    final id = os.held.keys.single;
    final payload = os.held[id];

    // Start over with a foreign request sitting on that id.
    os.held
      ..clear()
      ..[id] = 'foreign';
    os.notifications.clear();
    await at(now, s.reconcile);
    expect(os.held[id], 'foreign');
    expect(os.held.values, contains(payload));
  });

  test(
    'without permission nothing is scheduled, and the report says so',
    () async {
      os.permissionValue = NotificationPermission.denied;
      await daily('Vitamins');
      final report = await at(now, () => sync().reconcile());
      expect(os.scheduleCalls, isEmpty);
      expect(report.planned, 14);
      expect(report.verified, 0);
      expect(report.allScheduled, isFalse);
    },
  );

  test('only the soonest alerts are scheduled when over the cap', () async {
    await daily('Morning');
    final report = await at(now, () => sync(maxScheduled: 3).reconcile());
    expect(report.planned, 3);
    expect(os.heldNotifications.map((n) => n.at), [
      DateTime(2026, 10, 14, 9),
      DateTime(2026, 10, 15, 9),
      DateTime(2026, 10, 16, 9),
    ]);
  });

  test(
    'after a restart, schedules survive and nothing is duplicated',
    () async {
      await daily('Vitamins');
      await at(now, () => sync().reconcile());
      final held = Map.of(os.held);
      os.clearCalls();

      // New process, same macOS state.
      await at(now, () => sync().reconcile());
      expect(os.scheduleCalls, isEmpty);
      expect(os.held, held);

      // macOS lost everything (e.g. notifications reset): all come back.
      os.held.clear();
      os.notifications.clear();
      final report = await at(now, () => sync().reconcile());
      expect(report.verified, 14);
    },
  );

  test(
    'task deadline reminders follow due time, offset and completion',
    () async {
      final id = await tasks.create(
        TaskDraft(
          title: 'Submit report',
          dueDate: today,
          dueMinutes: 14 * 60,
          reminderOffsetMinutes: 30,
        ),
      );
      await tasks.create(
        TaskDraft(title: 'No reminder', dueDate: today, dueMinutes: 15 * 60),
      );
      final s = sync();
      await at(now, s.reconcile);
      final alert = os.heldNotifications.single;
      expect(alert.at, DateTime(2026, 10, 14, 13, 30));
      expect(alert.kind, NotificationKind.task);
      expect(alert.body, 'Due today at 14:00');

      await at(now, () => tasks.complete(id));
      await at(now, s.reconcile);
      expect(os.held, isEmpty);
    },
  );

  test('a date-only task reminds at the default time from settings', () async {
    await tasks.create(
      TaskDraft(
        title: 'Pay rent',
        dueDate: DateTime(2026, 10, 15),
        reminderOffsetMinutes: 0,
      ),
    );
    await settings.setDefaultReminderMinutes(8 * 60);
    await at(now, () => sync().reconcile());
    expect(os.heldNotifications.single.at, DateTime(2026, 10, 15, 8));
  });

  test('passed alerts are logged once as Due', () async {
    await daily('Vitamins');
    final s = sync();
    await at(now, s.reconcile);
    await at(DateTime(2026, 10, 15, 9, 30), s.reconcile);
    await at(DateTime(2026, 10, 15, 9, 45), s.reconcile);

    final events = await reminders.watchEvents().first;
    expect(events.map((e) => (e.kind, e.at)), [
      (ReminderEventKind.due, DateTime(2026, 10, 15, 9)),
      (ReminderEventKind.due, DateTime(2026, 10, 14, 9)),
    ]);
  });

  group('notification actions', () {
    test('Done on a one-time reminder finishes it and logs Done', () async {
      final id = await reminders.create(
        ReminderDraft(title: 'Call bank', date: today, minutes: 9 * 60),
      );
      final s = sync();
      await at(now, s.attach);
      await at(now, s.reconcile);
      final payload = os.held.values.single;

      await at(now, () async {
        os.onResponse!((payload: payload, action: NotificationActionType.done));
        await pumpEventQueue();
      });
      expect((await reminders.reminder(id))!.completedAt, isNotNull);
      final events = await reminders.watchEvents().first;
      expect(events.first.kind, ReminderEventKind.done);
      await at(now, s.reconcile);
      expect(os.held, isEmpty);
    });

    test('Snooze re-alerts in 10 minutes', () async {
      final id = await reminders.create(
        ReminderDraft(title: 'Stand up', date: today, minutes: 9 * 60),
      );
      final s = sync();
      await at(now, s.attach);
      final nineOClock = DateTime(2026, 10, 14, 9);
      await at(nineOClock, () async {
        os.onResponse!((
          payload: PlannedNotification(
            kind: NotificationKind.reminder,
            target: '$id',
            at: nineOClock,
            title: 'Stand up',
          ).payload,
          action: NotificationActionType.snooze,
        ));
        await pumpEventQueue();
      });
      await at(nineOClock, s.reconcile);
      expect(os.heldNotifications.single.at, DateTime(2026, 10, 14, 9, 10));
    });

    test('Complete on a task reminder completes the task', () async {
      final id = await tasks.create(
        TaskDraft(
          title: 'Send invoice',
          dueDate: today,
          dueMinutes: 10 * 60,
          reminderOffsetMinutes: 0,
        ),
      );
      final s = sync();
      await at(now, s.attach);
      await at(now, s.reconcile);
      final payload = os.held.values.single;
      await at(now, () async {
        os.onResponse!((payload: payload, action: NotificationActionType.done));
        await pumpEventQueue();
      });
      expect((await tasks.task(id))!.isCompleted, isTrue);
    });

    test('tapping opens the item; the launch tap waits for the UI', () async {
      final s = sync();
      os.launchResponse = (
        payload: 'dm1|task|5|100|x',
        action: NotificationActionType.open,
      );
      await at(now, s.attach);
      expect(s.pendingOpen, (kind: NotificationKind.task, target: '5'));

      final opened = s.openRequests.first;
      os.onResponse!((
        payload: 'dm1|reminder|3|100|x',
        action: NotificationActionType.open,
      ));
      expect(await opened, (kind: NotificationKind.reminder, target: '3'));
      // Every response triggers a reconcile; let it finish.
      await at(now, s.reconcile);
    });
  });

  test('payloads parse back; foreign ones do not', () {
    final n = PlannedNotification(
      kind: NotificationKind.prayer,
      target: 'fajr',
      at: DateTime(2026, 10, 14, 4, 20),
      title: 'Subuh',
    );
    expect(parsePayload(n.payload), (
      kind: NotificationKind.prayer,
      target: 'fajr',
    ));
    expect(parsePayload('other|x'), isNull);
    expect(parsePayload(null), isNull);
    expect(
      n.payload,
      isNot(n.copyWith(title: 'Subuh (adjusted)').payload),
      reason: 'content changes must produce a new payload',
    );
  });
}
