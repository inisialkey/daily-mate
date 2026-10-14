import 'package:daily_mate/features/notes/presentation/markdown_editing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

TextEditingValue v(String text, int start, [int? end]) => TextEditingValue(
  text: text,
  selection: TextSelection(baseOffset: start, extentOffset: end ?? start),
);

void main() {
  test('bold wraps and unwraps the selection', () {
    final bold = toggleInline(v('make it pop', 8, 11), '**');
    expect(bold.text, 'make it **pop**');
    expect(
      bold.selection,
      const TextSelection(baseOffset: 10, extentOffset: 13),
    );
    expect(toggleInline(bold, '**').text, 'make it pop');
  });

  test('inline marker without selection inserts a placeholder', () {
    final value = toggleInline(v('a ', 2), '_', placeholder: 'italic');
    expect(value.text, 'a _italic_');
    expect(
      value.selection,
      const TextSelection(baseOffset: 3, extentOffset: 9),
    );
  });

  test('list prefix applies to every selected line, and toggles off', () {
    final listed = toggleLinePrefix(v('one\ntwo\nthree', 1, 6), '- ');
    expect(listed.text, '- one\n- two\nthree');
    expect(toggleLinePrefix(listed, '- ').text, 'one\ntwo\nthree');
  });

  test('checklist prefix on the cursor line only', () {
    expect(toggleLinePrefix(v('a\nb', 2), '- [ ] ').text, 'a\n- [ ] b');
  });

  test('link wraps the selection and selects the url', () {
    final value = insertLink(v('see docs', 4, 8));
    expect(value.text, 'see [docs](url)');
    expect(
      value.text.substring(value.selection.start, value.selection.end),
      'url',
    );
  });

  test('an invalid selection appends at the end', () {
    const value = TextEditingValue(text: 'x');
    expect(toggleInline(value, '`', placeholder: 'code').text, 'x`code`');
  });
}
