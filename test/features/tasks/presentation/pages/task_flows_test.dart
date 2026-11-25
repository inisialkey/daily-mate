import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_checkbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  final today = dateOnly(DateTime.now());
  TaskRepository repo() => sl<TaskRepository>();

  Future<int> seed(WidgetTester tester, TaskDraft draft) async {
    final id = await tester.runAsync(() => repo().create(draft));
    await tester.pumpAndSettle();
    return id!;
  }

  testWidgets('⌘N quick-adds a task to Today', (tester) async {
    await pumpApp(tester);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
    await tester.pumpAndSettle();

    expect(find.text('Add Task'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, 'Buy milk');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Add Task'), findsNothing);
    expect(find.text('Buy milk'), findsOneWidget);
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.dueDate, today);
  });

  Future<void> openQuickAdd(WidgetTester tester) async {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
    await tester.pumpAndSettle();
  }

  testWidgets('⌘N reads the day, time and priority out of the title', (
    tester,
  ) async {
    await pumpApp(tester);
    await openQuickAdd(tester);
    final dialog = find.byType(Dialog);

    await tester.enterText(
      find.byType(TextField).last,
      'Review PR besok 14:00 !1',
    );
    await tester.pump();
    expect(
      find.descendant(of: dialog, matching: find.text('Tomorrow')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dialog, matching: find.text('High')),
      findsOneWidget,
    );

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(dialog, findsNothing);
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    final task = saved!.single;
    expect(task.title, 'Review PR');
    expect(task.dueDate, addDays(today, 1));
    expect(task.dueMinutes, 14 * 60);
    expect(task.priority, Priority.high);
  });

  testWidgets('⌘N: picking a date replaces the typed one', (tester) async {
    await pumpApp(tester);
    await openQuickAdd(tester);
    final dialog = find.byType(Dialog);
    final field = find.byType(TextField).last;

    await tester.enterText(field, 'Review PR besok !2');
    await tester.pump();
    await tester.tap(
      find.descendant(of: dialog, matching: find.text('Tomorrow')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Today').last);
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(field).controller!.text, 'Review PR !2');
    expect(
      find.descendant(of: dialog, matching: find.text('Today')),
      findsOneWidget,
    );

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.title, 'Review PR');
    expect(saved.single.dueDate, today);
    expect(saved.single.priority, Priority.medium);
  });

  testWidgets('⌘N: a picked date is not replaced by a later date word', (
    tester,
  ) async {
    await pumpApp(tester);
    await openQuickAdd(tester);
    final dialog = find.byType(Dialog);
    final field = find.byType(TextField).last;

    await tester.enterText(field, 'Call mom today about Sunday dinner');
    await tester.pump();
    await tester.tap(find.descendant(of: dialog, matching: find.text('Today')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tomorrow').last);
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(field).controller!.text,
      'Call mom about Sunday dinner',
    );
    expect(
      find.descendant(of: dialog, matching: find.text('Tomorrow')),
      findsOneWidget,
    );

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.title, 'Call mom about Sunday dinner');
    expect(saved.single.dueDate, addDays(today, 1));
  });

  testWidgets('⌘N: a picked priority is not replaced by a later one', (
    tester,
  ) async {
    await pumpApp(tester);
    await openQuickAdd(tester);
    final dialog = find.byType(Dialog);
    final field = find.byType(TextField).last;

    await tester.enterText(field, 'Fix !1 bug !2');
    await tester.pump();
    await tester.tap(find.descendant(of: dialog, matching: find.text('High')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Low').last);
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(field).controller!.text, 'Fix bug !2');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.title, 'Fix bug !2');
    expect(saved.single.priority, Priority.low);
  });

  testWidgets('⌘N on Today: a repeat keeps the typed day too', (tester) async {
    await pumpApp(tester);
    await openQuickAdd(tester);
    final dialog = find.byType(Dialog);
    final field = find.byType(TextField).last;

    await tester.enterText(field, 'Gym besok');
    await tester.pump();
    await tester.tap(find.descendant(of: dialog, matching: find.text('Never')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Every Day').last);
    await tester.pumpAndSettle();
    await tester.enterText(field, 'Gym');
    await tester.pump();

    expect(
      find.descendant(of: dialog, matching: find.text('Tomorrow')),
      findsOneWidget,
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.dueDate, addDays(today, 1));
    expect(saved.single.recurrence, isNotNull);
  });

  testWidgets('⌘N: "jam 12 malam" is due after midnight, tomorrow', (
    tester,
  ) async {
    await pumpApp(tester);
    await openQuickAdd(tester);
    final dialog = find.byType(Dialog);

    await tester.enterText(find.byType(TextField).last, 'Tidur jam 12 malam');
    await tester.pump();
    expect(
      find.descendant(of: dialog, matching: find.text('Tomorrow')),
      findsOneWidget,
    );

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.title, 'Tidur');
    expect(saved.single.dueDate, addDays(today, 1));
    expect(saved.single.dueMinutes, 0);
  });

  testWidgets('⌘N: a picked date is not moved past midnight', (tester) async {
    await pumpApp(tester);
    await openQuickAdd(tester);
    final dialog = find.byType(Dialog);

    await tester.enterText(find.byType(TextField).last, 'Tidur jam 12 malam');
    await tester.pump();
    await tester.tap(
      find.descendant(of: dialog, matching: find.text('Tomorrow')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Today').last);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: dialog, matching: find.text('Today')),
      findsOneWidget,
    );

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.title, 'Tidur');
    expect(saved.single.dueDate, today);
    expect(saved.single.dueMinutes, 0);
  });

  for (final onToday in [true, false]) {
    testWidgets('⌘N ${onToday ? 'on Today' : 'on All Tasks'}: a picked time '
        'is on the typed night, not after its midnight', (tester) async {
      String timeLabel(int hour) =>
          DateFormat.jm().format(DateTime(2000, 1, 1, hour));
      await pumpApp(tester);
      if (!onToday) {
        await tester.tap(find.text('All Tasks'));
        await tester.pumpAndSettle();
      }
      await openQuickAdd(tester);
      final dialog = find.byType(Dialog);

      await tester.enterText(find.byType(TextField).last, 'Tidur jam 12 malam');
      await tester.pump();
      expect(
        find.descendant(of: dialog, matching: find.text('Tomorrow')),
        findsOneWidget,
      );
      await tester.tap(
        find.descendant(of: dialog, matching: find.text(timeLabel(0))),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(timeLabel(21)).last);
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: dialog, matching: find.text('Today')),
        findsOneWidget,
      );

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      final saved = await tester.runAsync(
        () => repo().tasks(const TaskFilter()),
      );
      expect(saved!.single.title, 'Tidur');
      expect(saved.single.dueDate, today);
      expect(saved.single.dueMinutes, 21 * 60);
    });
  }

  testWidgets('⌘N: after Remove Date a typed time still counts', (
    tester,
  ) async {
    await pumpApp(tester);
    await openQuickAdd(tester);
    final dialog = find.byType(Dialog);

    await tester.tap(find.descendant(of: dialog, matching: find.text('Today')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove Date'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: dialog, matching: find.text('No date')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tomorrow').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Rapat jam 14');
    await tester.pump();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.title, 'Rapat');
    expect(saved.single.dueDate, addDays(today, 1));
    expect(saved.single.dueMinutes, 14 * 60);
  });

  testWidgets('⌘N: "malam minggu" is Saturday; a picked date keeps the '
      '"malam" of the typed time', (tester) async {
    await pumpApp(tester);
    await openQuickAdd(tester);
    final dialog = find.byType(Dialog);
    final field = find.byType(TextField).last;
    final untilSunday = DateTime.sunday - today.weekday;
    final saturday = addDays(today, (untilSunday == 0 ? 7 : untilSunday) - 1);

    await tester.enterText(field, 'Nonton jam 8 malam minggu');
    await tester.pump();
    expect(
      find.descendant(
        of: dialog,
        matching: find.text(formatRelativeDay(saturday, today)),
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(
        of: dialog,
        matching: find.byIcon(CupertinoIcons.calendar),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Today').last);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(field).controller!.text,
      'Nonton jam 8 malam',
    );

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.title, 'Nonton');
    expect(saved.single.dueDate, today);
    expect(saved.single.dueMinutes, 20 * 60);
  });

  testWidgets('⌘N: a repeat keeps the typed day after the word is deleted', (
    tester,
  ) async {
    await pumpApp(tester);
    // Outside Today, ⌘N starts without a date.
    await tester.tap(find.text('All Tasks'));
    await tester.pumpAndSettle();
    await openQuickAdd(tester);
    final dialog = find.byType(Dialog);
    final field = find.byType(TextField).last;

    await tester.enterText(field, 'Gym besok');
    await tester.pump();
    await tester.tap(find.descendant(of: dialog, matching: find.text('Never')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Every Day').last);
    await tester.pumpAndSettle();
    await tester.enterText(field, 'Gym');
    await tester.pump();

    expect(
      find.descendant(of: dialog, matching: find.text('Tomorrow')),
      findsOneWidget,
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.dueDate, addDays(today, 1));
    expect(saved.single.recurrence, isNotNull);
  });

  testWidgets('completing offers Undo, which reopens the task', (tester) async {
    await pumpApp(tester);
    final id = await seed(
      tester,
      TaskDraft(title: 'Water plants', dueDate: today),
    );

    await tester.tap(find.byType(TaskCheckbox));
    await tester.pumpAndSettle();
    expect(find.text('Completed “Water plants”'), findsOneWidget);
    expect((await tester.runAsync(() => repo().task(id)))!.isCompleted, isTrue);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(
      (await tester.runAsync(() => repo().task(id)))!.isCompleted,
      isFalse,
    );
  });

  testWidgets('the inspector sets the status and the row shows it', (
    tester,
  ) async {
    await pumpApp(tester);
    final id = await seed(
      tester,
      TaskDraft(title: 'Water plants', dueDate: today),
    );

    await tester.tap(find.text('Water plants'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('To Do'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('In Progress'));
    await tester.pumpAndSettle();
    await settleAsync(tester);
    await tester.pumpAndSettle();

    // The inspector's button and the task row's label.
    expect(find.text('In Progress'), findsNWidgets(2));
    expect(
      (await tester.runAsync(() => repo().task(id)))!.progress,
      TaskProgress.inProgress,
    );
  });

  testWidgets('All Tasks filters by status', (tester) async {
    await pumpApp(
      tester,
      seed: () async {
        await repo().create(const TaskDraft(title: 'Waiting'));
        final id = await repo().create(const TaskDraft(title: 'Started'));
        await repo().setProgress(id, TaskProgress.inProgress);
      },
    );
    await tester.tap(find.text('All Tasks'));
    await tester.pumpAndSettle();
    await settleAsync(tester);
    await tester.pumpAndSettle();
    expect(find.text('Waiting'), findsOneWidget);

    await tester.tap(
      find.widgetWithText(SegmentedButton<TaskStatus>, 'In Progress'),
    );
    await tester.pumpAndSettle();
    await settleAsync(tester);
    await tester.pumpAndSettle();

    expect(find.text('Waiting'), findsNothing);
    expect(find.text('Started'), findsOneWidget);
  });

  testWidgets('the inspector edits and saves the title', (tester) async {
    await pumpApp(tester);
    final id = await seed(
      tester,
      TaskDraft(title: 'Water plants', dueDate: today),
    );

    await tester.tap(find.text('Water plants'));
    await tester.pumpAndSettle();
    expect(find.text('Mark Complete'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Water plants'),
      'Water all plants',
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(
      (await tester.runAsync(() => repo().task(id)))!.title,
      'Water all plants',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Mark Complete'), findsNothing);
  });

  testWidgets('right-click → Delete asks first, then deletes', (tester) async {
    await pumpApp(tester);
    await seed(tester, TaskDraft(title: 'Old idea', dueDate: today));

    await tester.tap(find.text('Old idea'), buttons: kSecondaryButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete…'));
    await tester.pumpAndSettle();
    expect(find.text('Delete task?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Old idea'), findsNothing);
    expect(
      await tester.runAsync(() => repo().tasks(const TaskFilter())),
      isEmpty,
    );
  });

  testWidgets('Upcoming adds a task to the chosen day', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Upcoming'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byTooltip('Add task to ${_tomorrowTitle(tester)}').first,
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Dentist');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final saved = await tester.runAsync(() => repo().tasks(const TaskFilter()));
    expect(saved!.single.dueDate, addDays(today, 1));
    expect(find.text('Dentist'), findsOneWidget);
  });

  testWidgets('All Tasks filters by search', (tester) async {
    await pumpApp(tester);
    await seed(tester, const TaskDraft(title: 'Pay rent'));
    await seed(tester, const TaskDraft(title: 'Call mom'));
    await tester.tap(find.text('All Tasks'));
    await tester.pumpAndSettle();
    expect(find.text('Pay rent'), findsOneWidget);
    expect(find.text('Call mom'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Search tasks'),
      'rent',
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Pay rent'), findsOneWidget);
    expect(find.text('Call mom'), findsNothing);
  });
}

/// The section title Upcoming uses for tomorrow, e.g. "Tomorrow · Thu 15 Oct".
String _tomorrowTitle(WidgetTester tester) {
  final header = find.textContaining('Tomorrow · ').evaluate().first.widget;
  return (header as Text).data!;
}
