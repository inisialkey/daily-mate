import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/features/notes/presentation/markdown_editing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Formatting buttons; [onFormat] applies an edit to the Markdown source
/// (and must save it — programmatic changes skip `onChanged`).
class MarkdownToolbar extends StatelessWidget {
  const MarkdownToolbar({
    required this.onFormat,
    required this.focusNode,
    super.key,
  });

  final void Function(TextEditingValue Function(TextEditingValue)) onFormat;
  final FocusNode focusNode;

  void _apply(TextEditingValue Function(TextEditingValue) edit) {
    onFormat(edit);
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    Widget button(String tooltip, Widget icon, VoidCallback onPressed) =>
        IconButton(tooltip: tooltip, onPressed: onPressed, icon: icon);
    Widget glyph(String text, {FontWeight? weight, FontStyle? style}) => Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: weight ?? FontWeight.w600,
        fontStyle: style,
      ),
    );
    return Wrap(
      spacing: Space.xxs,
      children: [
        button(
          'Heading',
          glyph('H'),
          () => _apply((v) => toggleLinePrefix(v, '## ')),
        ),
        button(
          'Bold  ⌘B',
          glyph('B', weight: FontWeight.w800),
          () => _apply((v) => toggleInline(v, '**', placeholder: 'bold')),
        ),
        button(
          'Italic  ⌘I',
          glyph('I', weight: FontWeight.w500, style: FontStyle.italic),
          () => _apply((v) => toggleInline(v, '_', placeholder: 'italic')),
        ),
        button(
          'Bulleted list',
          const Icon(CupertinoIcons.list_bullet),
          () => _apply((v) => toggleLinePrefix(v, '- ')),
        ),
        button(
          'Checklist',
          const Icon(CupertinoIcons.checkmark_square),
          () => _apply((v) => toggleLinePrefix(v, '- [ ] ')),
        ),
        button(
          'Quote',
          const Icon(CupertinoIcons.text_quote),
          () => _apply((v) => toggleLinePrefix(v, '> ')),
        ),
        button(
          'Code',
          const Icon(CupertinoIcons.chevron_left_slash_chevron_right),
          () => _apply((v) => toggleInline(v, '`', placeholder: 'code')),
        ),
        button(
          'Link',
          const Icon(CupertinoIcons.link),
          () => _apply(insertLink),
        ),
      ],
    );
  }
}
