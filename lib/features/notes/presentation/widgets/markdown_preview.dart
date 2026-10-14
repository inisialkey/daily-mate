import 'dart:async';

import 'package:daily_mate/core/platform/window_channel.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

/// Read-only rendering of a note. Links open in the default browser.
class MarkdownPreview extends StatelessWidget {
  const MarkdownPreview({required this.data, super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final colors = theme.colorScheme;
    final mono = text.bodyMedium?.copyWith(
      fontFamily: 'Menlo',
      fontSize: 13,
      backgroundColor: colors.surfaceContainer,
    );
    final style = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: text.bodyLarge,
      h1: text.headlineSmall,
      h2: text.titleLarge,
      h3: text.titleMedium,
      listBullet: text.bodyLarge,
      code: mono,
      a: TextStyle(
        color: colors.primary,
        decoration: TextDecoration.underline,
        decorationColor: colors.primary,
      ),
      blockSpacing: Space.md,
      codeblockPadding: const EdgeInsets.all(Space.md),
      codeblockDecoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      blockquote: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
      blockquotePadding: const EdgeInsets.only(left: Space.md),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: colors.outlineVariant, width: 3),
        ),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
    );

    if (data.trim().isEmpty) {
      return Text(
        'Nothing to preview yet.',
        style: text.bodyLarge?.copyWith(color: context.palette.textMuted),
      );
    }
    return MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: style,
      onTapLink: (_, href, _) {
        if (href != null) unawaited(WindowChannel.openUrl(href));
      },
      checkboxBuilder: (checked) => Padding(
        padding: const EdgeInsets.only(right: Space.sm),
        child: Icon(
          checked
              ? CupertinoIcons.checkmark_square_fill
              : CupertinoIcons.square,
          size: IconSizes.md,
          color: checked ? colors.primary : colors.outline,
          semanticLabel: checked ? 'Done' : 'Not done',
        ),
      ),
    );
  }
}
