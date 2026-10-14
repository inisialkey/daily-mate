import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Future<void> openSearch(WidgetTester tester) async {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, String text) async {
    await tester.enterText(
      find.widgetWithText(TextField, 'Search tasks, notes and reminders'),
      text,
    );
    await tester.pump(const Duration(milliseconds: 200));
    await settleAsync(tester);
    await tester.pumpAndSettle();
  }

  testWidgets('⌘K finds tasks and notes and opens the chosen one', (
    tester,
  ) async {
    await pumpApp(
      tester,
      seed: () async {
        await sl<TaskRepository>().create(
          const TaskDraft(title: 'Renew passport'),
        );
        await sl<NoteRepository>().create(title: 'Passport checklist');
      },
    );
    await openSearch(tester);
    await type(tester, 'passport');

    expect(find.text('Renew passport'), findsOneWidget);
    expect(find.text('Passport checklist'), findsOneWidget);

    // ↓ moves to the note; ↩ opens it.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await settleAsync(tester);

    expect(find.text('Search tasks, notes and reminders'), findsNothing);
    expect(
      find.widgetWithText(TextField, 'Passport checklist'),
      findsOneWidget,
    );
  });

  testWidgets('no matches says so', (tester) async {
    await pumpApp(tester);
    await openSearch(tester);
    await type(tester, 'zzz');
    expect(find.text('Nothing matches “zzz”.'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Search tasks, notes and reminders'), findsNothing);
  });
}
