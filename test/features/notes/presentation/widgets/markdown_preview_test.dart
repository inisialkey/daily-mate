import 'package:daily_mate/core/theme/app_theme.dart';
import 'package:daily_mate/features/notes/presentation/widgets/markdown_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// A 1×1 PNG.
const _dot =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB'
    '0C8AAAAASUVORK5CYII=';

Future<void> _pumpPreview(WidgetTester tester, String data) =>
    tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: MarkdownPreview(data: data)),
      ),
    );

final Finder _webImage = find.byWidgetPredicate(
  (widget) => widget is Image && widget.image is NetworkImage,
);

void main() {
  testWidgets('a web image is never loaded: it is a link to the browser', (
    tester,
  ) async {
    const channel = MethodChannel('dailymate/window');
    final calls = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (call) async => calls.add('${call.method} ${call.arguments}'),
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );

    await _pumpPreview(
      tester,
      'Our logo: ![Company logo](https://example.com/logo.png)',
    );
    expect(_webImage, findsNothing);

    await tester.tap(find.text('Company logo'));
    expect(calls, ['openUrl https://example.com/logo.png']);
  });

  testWidgets('a web image without a description shows its address', (
    tester,
  ) async {
    await _pumpPreview(tester, '![](http://example.com/logo.png)');
    expect(_webImage, findsNothing);
    expect(find.text('http://example.com/logo.png'), findsOneWidget);
  });

  testWidgets('an embedded image still shows', (tester) async {
    await _pumpPreview(tester, '![Dot](data:image/png;base64,$_dot)');
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && widget.image is MemoryImage,
      ),
      findsOneWidget,
    );
  });
}
