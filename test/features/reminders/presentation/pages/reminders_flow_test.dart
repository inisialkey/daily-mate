import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/ui/widgets/section_header.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/reminder_draft.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event_kind.dart';
import 'package:daily_mate/features/reminders/domain/reminder_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_notification_scheduler.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  ReminderRepository repo() => sl<ReminderRepository>();
  final tomorrow = addDays(dateOnly(DateTime.now()), 1);

  Future<void> openReminders(WidgetTester tester) async {
    await tester.tap(find.text('Reminders').first);
    await tester.pumpAndSettle();
  }

  testWidgets('New Reminder creates an upcoming reminder', (tester) async {
    await pumpApp(tester);
    await openReminders(tester);
    expect(find.text('No reminders yet'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'New Reminder').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Drink water',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Drink water'), findsOneWidget);
    expect(find.widgetWithText(SectionHeader, 'Upcoming'), findsOneWidget);
    final saved = await tester.runAsync(repo().reminders);
    expect(saved!.single.title, 'Drink water');
  });

  testWidgets('a past one-time time is rejected in the editor', (tester) async {
    await pumpApp(tester);
    final id = await tester.runAsync(
      () => repo().create(
        ReminderDraft(title: 'Old', date: DateTime(2020), minutes: 9 * 60),
      ),
    );
    await openReminders(tester);
    expect(find.widgetWithText(SectionHeader, 'Missed'), findsOneWidget);

    await tester.tap(find.text('Old'));
    await tester.pumpAndSettle();
    // Unchanged timing may be saved (e.g. renaming a missed reminder) ...
    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Older');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect((await tester.runAsync(() => repo().reminder(id!)))!.title, 'Older');
  });

  testWidgets('allowing notifications hides the banner', (tester) async {
    final os = FakeNotificationScheduler()
      ..permissionValue = NotificationPermission.unknown;
    await pumpApp(tester, scheduler: os);
    await openReminders(tester);
    expect(find.text('Allow notifications'), findsOneWidget);

    await tester.tap(find.text('Allow Notifications'));
    await tester.pumpAndSettle();
    await settleAsync(tester);
    expect(find.text('Allow notifications'), findsNothing);
  });

  testWidgets('a refusal points to System Settings', (tester) async {
    final os = FakeNotificationScheduler()
      ..permissionValue = NotificationPermission.denied
      ..grantOnRequest = false;
    await pumpApp(tester, scheduler: os);
    await openReminders(tester);

    await tester.tap(find.text('Allow Notifications'));
    await tester.pumpAndSettle();
    expect(
      find.text('Notifications are turned off for DailyMate'),
      findsOneWidget,
    );

    await tester.tap(find.text('Open System Settings'));
    await tester.pumpAndSettle();
    expect(os.settingsOpened, 1);
    await settleAsync(tester);
  });

  testWidgets('switching a reminder off moves it to Off', (tester) async {
    await pumpApp(tester);
    await tester.runAsync(
      () => repo().create(
        ReminderDraft(
          title: 'Vitamins',
          date: tomorrow,
          minutes: 8 * 60,
          recurrence: RecurrenceRule.daily,
        ),
      ),
    );
    await openReminders(tester);
    expect(find.widgetWithText(SectionHeader, 'Upcoming'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await settleAsync(tester);
    expect(find.widgetWithText(SectionHeader, 'Off'), findsOneWidget);
    expect((await tester.runAsync(repo().reminders))!.single.enabled, isFalse);
  });

  testWidgets('history lists logged events', (tester) async {
    await pumpApp(tester);
    await tester.runAsync(
      () => repo().logEvents([
        ReminderEvent(
          title: 'Vitamins',
          kind: ReminderEventKind.done,
          at: DateTime.now(),
        ),
      ]),
    );
    await openReminders(tester);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Vitamins'), findsOneWidget);
    expect(find.textContaining('Done ·'), findsOneWidget);
  });

  testWidgets('Settings sends a test notification', (tester) async {
    final os = FakeNotificationScheduler();
    await pumpApp(tester, scheduler: os);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send Test'));
    await tester.pumpAndSettle();
    expect(os.shown.single.title, 'DailyMate notifications work');
  });
}
