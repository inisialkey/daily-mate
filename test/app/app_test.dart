import 'package:daily_mate/app/destinations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('sidebar shows every destination and navigates', (tester) async {
    await pumpApp(tester);

    for (final destination in AppDestination.values) {
      expect(find.text(destination.label), findsWidgets);
    }

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    expect(find.text('No notes yet'), findsOneWidget);
  });

  testWidgets('⌘2 opens Upcoming and ⌘, opens Settings', (tester) async {
    await pumpApp(tester);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.sendKeyEvent(LogicalKeyboardKey.comma);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsOneWidget);
  });

  testWidgets('theme can be switched to dark and light', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Appearance'))).brightness,
      Brightness.dark,
    );

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Appearance'))).brightness,
      Brightness.light,
    );
  });

  testWidgets('narrow windows collapse the sidebar to icons', (tester) async {
    await pumpApp(tester, size: const Size(900, 700));
    expect(find.text('Upcoming'), findsNothing);
    expect(find.byTooltip('Upcoming  ⌘2'), findsOneWidget);
  });
}
