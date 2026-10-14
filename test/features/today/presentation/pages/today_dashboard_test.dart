import 'package:clock/clock.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/notes/domain/note_filter.dart';
import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('first use shows the checklist and the prayer prompt', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.text('Get started with DailyMate'), findsOneWidget);
    expect(find.text('Prayer times'), findsOneWidget);
    expect(find.text('Coming up'), findsOneWidget);

    await tester.tap(find.byTooltip('Dismiss'));
    await tester.pumpAndSettle();
    await settleAsync(tester);
    expect(find.text('Get started with DailyMate'), findsNothing);
    expect(
      (await tester.runAsync(sl<SettingsRepository>().load))!.welcomeDismissed,
      isTrue,
    );
  });

  testWidgets('quick capture saves a note', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Note'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Capture a note'),
      'Gift ideas for Ibu',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await settleAsync(tester);

    final notes = await tester.runAsync(
      () => sl<NoteRepository>().notes(const NoteFilter()),
    );
    expect(notes!.single.title, 'Gift ideas for Ibu');
    expect(find.text('Note saved'), findsOneWidget);
  });

  testWidgets('list keys work after a click but not while typing', (
    tester,
  ) async {
    // Wide enough for the inspector to sit beside the list.
    await pumpApp(
      tester,
      size: const Size(1600, 900),
      seed: () async {
        final today = dateOnly(clock.now());
        await sl<TaskRepository>().create(
          TaskDraft(title: 'First', dueDate: today),
        );
        await sl<TaskRepository>().create(
          TaskDraft(title: 'Second', dueDate: today),
        );
      },
    );
    await tester.tap(find.text('First'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Second'), findsOneWidget);

    // ⌫ in the quick-capture field edits the text; it must not delete the
    // selected task.
    await tester.enterText(
      find.widgetWithText(TextField, 'Add a task for today'),
      'Milk',
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pumpAndSettle();
    expect(find.text('Delete task?'), findsNothing);
    expect(find.text('Mil'), findsOneWidget);

    await tester.tap(find.text('First'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Mark Complete'), findsNothing);
  });

  testWidgets('narrow windows stack the prayer glance above the tasks', (
    tester,
  ) async {
    await pumpApp(tester, size: const Size(900, 760));
    expect(find.text('Prayer times'), findsOneWidget);
    expect(find.text('Coming up'), findsNothing);
  });
}
