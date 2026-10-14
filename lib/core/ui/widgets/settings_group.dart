import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Titled, bordered group of [SettingsRow]s separated by hairlines.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    required this.title,
    required this.children,
    super.key,
    this.description,
  });

  final String title;
  final String? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final description = this.description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: context.text.titleMedium),
        ),
        if (description != null) ...[
          const SizedBox(height: Space.xxs),
          Text(
            description,
            style: context.text.bodySmall?.copyWith(
              color: context.palette.textMuted,
            ),
          ),
        ],
        const SizedBox(height: Space.sm),
        Card(
          child: Column(
            children: [
              for (final (i, child) in children.indexed) ...[
                if (i > 0) const Divider(indent: Space.lg),
                child,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    final leading = this.leading;
    final trailing = this.trailing;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.md,
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading, const SizedBox(width: Space.md)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: Space.xxs),
                  Text(
                    subtitle,
                    style: context.text.bodySmall?.copyWith(
                      color: context.palette.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: Space.lg),
            trailing,
          ],
        ],
      ),
    );
  }
}
