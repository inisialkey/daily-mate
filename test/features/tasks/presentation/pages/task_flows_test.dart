import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_checkbox.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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
