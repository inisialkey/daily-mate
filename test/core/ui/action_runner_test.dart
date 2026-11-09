import 'dart:async';

import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a confirmation with Undo dismisses itself', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => unawaited(
                runAction(
                  context,
                  () async {},
                  success: 'Completed',
                  undo: () async {},
                ),
              ),
              child: const Text('Run'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Run'));
    await tester.pumpAndSettle();
    expect(find.text('Undo'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('Completed'), findsNothing);
  });
}
