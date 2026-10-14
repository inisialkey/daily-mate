import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/features/notes/domain/note_filter.dart';
import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  NoteRepository repo() => sl<NoteRepository>();

  Future<void> newNote(WidgetTester tester) async {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
    await tester.pumpAndSettle();
  }

  testWidgets('⇧⌘N starts a note that survives switching sections', (
    tester,
  ) async {
    await pumpApp(tester);
    await newNote(tester);
    expect(find.text('Select a note'), findsNothing);

    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Groceries',
    );
    await tester.enterText(
      find.byWidgetPredicate(
        (w) =>
            w is TextField &&
            w.decoration?.hintText?.startsWith('Write') == true,
      ),
      '# List\n- rice\n- eggs',
    );
    // Leave before the autosave pause: the section switch must not lose it.
    await tester.tap(find.text('Today'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    final notes = await tester.runAsync(() => repo().notes(const NoteFilter()));
    expect(notes!.single.title, 'Groceries');
    expect(notes.single.body, '# List\n- rice\n- eggs');

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    expect(find.text('Groceries'), findsWidgets);
  });

  testWidgets('preview renders Markdown; an empty new note is discarded', (
    tester,
  ) async {
    await pumpApp(tester);
    final id = await tester.runAsync(
      () => repo().create(title: 'Recipe', body: '## Rendang\n**slow** cook'),
    );
    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Recipe'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Preview'));
    await tester.pumpAndSettle();
    expect(find.text('Rendang'), findsOneWidget);

    // A new note left empty disappears when another note is opened.
    await newNote(tester);
    await tester.tap(find.text('Recipe'));
    await tester.pumpAndSettle();
    await settleAsync(tester);
    final notes = await tester.runAsync(() => repo().notes(const NoteFilter()));
    expect(notes!.map((n) => n.id), [id]);
  });
}
