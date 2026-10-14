import 'package:flutter/services.dart';

/// Wraps the selection in [marker] (`**`, `_`, `` ` ``), or unwraps it when
/// it is already wrapped. With nothing selected, inserts a selected
/// [placeholder] between markers so typing replaces it.
TextEditingValue toggleInline(
  TextEditingValue value,
  String marker, {
  String placeholder = 'text',
}) {
  final text = value.text;
  final selection = _validSelection(value);
  final start = selection.start;
  final end = selection.end;
  final m = marker.length;

  final wrapped =
      start >= m &&
      end + m <= text.length &&
      text.substring(start - m, start) == marker &&
      text.substring(end, end + m) == marker;
  if (wrapped) {
    return TextEditingValue(
      text: text
          .replaceRange(end, end + m, '')
          .replaceRange(start - m, start, ''),
      selection: TextSelection(baseOffset: start - m, extentOffset: end - m),
    );
  }
  final inner = start == end ? placeholder : text.substring(start, end);
  return TextEditingValue(
    text: text.replaceRange(start, end, '$marker$inner$marker'),
    selection: TextSelection(
      baseOffset: start + m,
      extentOffset: start + m + inner.length,
    ),
  );
}

/// Adds [prefix] (`# `, `- `, `- [ ] `, `> `) to every selected line, or
/// removes it when all of them already have it.
TextEditingValue toggleLinePrefix(TextEditingValue value, String prefix) {
  final text = value.text;
  final selection = _validSelection(value);
  final lineStart = selection.start == 0
      ? 0
      : text.lastIndexOf('\n', selection.start - 1) + 1;
  final nextBreak = text.indexOf('\n', selection.end);
  final lineEnd = nextBreak == -1 ? text.length : nextBreak;
  final lines = text.substring(lineStart, lineEnd).split('\n');
  final remove = lines.every((line) => line.startsWith(prefix));
  final changed = [
    for (final line in lines)
      remove ? line.substring(prefix.length) : '$prefix$line',
  ].join('\n');
  final delta = changed.length - (lineEnd - lineStart);
  return TextEditingValue(
    text: text.replaceRange(lineStart, lineEnd, changed),
    selection: TextSelection(
      baseOffset: lineStart,
      extentOffset: lineEnd + delta,
    ),
  );
}

/// Turns the selection into `[selection](url)` with "url" selected.
TextEditingValue insertLink(TextEditingValue value) {
  final selection = _validSelection(value);
  final label = selection.isCollapsed
      ? 'link'
      : value.text.substring(selection.start, selection.end);
  final inserted = '[$label](url)';
  final urlStart = selection.start + label.length + 3;
  return TextEditingValue(
    text: value.text.replaceRange(selection.start, selection.end, inserted),
    selection: TextSelection(baseOffset: urlStart, extentOffset: urlStart + 3),
  );
}

TextSelection _validSelection(TextEditingValue value) => value.selection.isValid
    ? value.selection
    : TextSelection.collapsed(offset: value.text.length);
