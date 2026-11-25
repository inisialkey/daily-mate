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

/// The window channel's calls, as "method arguments".
List<String> _windowCalls(WidgetTester tester) {
  const channel = MethodChannel('dailymate/window');
  final messenger = tester.binding.defaultBinaryMessenger;
  final calls = <String>[];
  messenger.setMockMethodCallHandler(
    channel,
    (call) async => calls.add('${call.method} ${call.arguments}'),
  );
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
  return calls;
}

void main() {
  testWidgets('a web image is never loaded: it is a link to the browser', (
    tester,
  ) async {
    final calls = _windowCalls(tester);
    await _pumpPreview(
      tester,
      'Our logo: ![Company logo](https://example.com/logo.png)',
    );
    expect(_webImage, findsNothing);

    await tester.tap(find.text('Company logo'));
    expect(calls, ['openUrl https://example.com/logo.png']);
  });

  testWidgets('a web image inside a link opens the link', (tester) async {
    final calls = _windowCalls(tester);
    await _pumpPreview(
      tester,
      '[![Build](https://img.example.com/badge.png)](https://ci.example.com)',
    );
    expect(_webImage, findsNothing);

    await tester.tap(find.text('Build'));
    expect(calls, ['openUrl https://ci.example.com']);
  });

  testWidgets('a web image without alt text shows its title or address', (
    tester,
  ) async {
    await _pumpPreview(
      tester,
      '![](https://example.com/logo.png "Company logo")\n\n'
      '![](http://example.com/logo.png)',
    );
    expect(_webImage, findsNothing);
    expect(find.text('Company logo'), findsOneWidget);
    expect(find.text('http://example.com/logo.png'), findsOneWidget);
  });

  testWidgets('a broken embedded image shows nothing', (tester) async {
    await _pumpPreview(
      tester,
      'Before ![Dot](data:image/png;base64,iVB) after',
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(Image), findsNothing);
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
