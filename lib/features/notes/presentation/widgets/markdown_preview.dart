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
      imageBuilder: (uri, title, alt) =>
          _image(uri, title, alt, style.p?.merge(style.a)),
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

/// A note never loads an image from the web: the app may connect out (for
/// MixMusic's covers in the menu bar panel), and a pasted image would tell
/// its server whenever the note is read. A web image is a link instead.
/// Only an embedded (`data:`) image is drawn, as it needs no connection.
/// Embedded text and file paths show nothing; a file path never showed
/// anyway, since the sandbox keeps the app out of your files.
Widget _image(Uri uri, String? title, String? alt, TextStyle? linkStyle) {
  if (uri.isScheme('http') || uri.isScheme('https')) {
    final label = [alt, title]
        .map((text) => text?.trim() ?? '')
        .firstWhere((text) => text.isNotEmpty, orElse: uri.toString);
    return _WebImageLink(uri: uri, label: label, style: linkStyle);
  }
  try {
    final data = uri.data;
    if (data != null && data.mimeType.startsWith('image/')) {
      return Image.memory(
        data.contentAsBytes(),
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      );
    }
  } on FormatException {
    // Broken base64, such as an image still being typed.
  }
  return const SizedBox.shrink();
}

/// A web image as a link: its alt text, title or address, opening the image
/// in the default browser.
class _WebImageLink extends StatelessWidget {
  const _WebImageLink({required this.uri, required this.label, this.style});

  final Uri uri;
  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(CupertinoIcons.photo, size: IconSizes.md, color: style?.color),
        const SizedBox(width: Space.xs),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
    // Inside a link the package wraps this in that link's GestureDetector,
    // which must get the tap; a detector here, being deeper, would win it.
    final inLink = identical(
      context.findAncestorWidgetOfExactType<GestureDetector>()?.child,
      this,
    );
    return Semantics(
      link: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: inLink
            ? content
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => unawaited(WindowChannel.openUrl(uri.toString())),
                child: content,
              ),
      ),
    );
  }
}
