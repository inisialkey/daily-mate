import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(
    this.title, {
    super.key,
    this.count,
    this.color,
    this.trailing,
  });

  final String title;
  final int? count;

  /// Accent for sections that need attention (e.g. overdue).
  final Color? color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final count = this.count;
    final trailing = this.trailing;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.xs, top: Space.xs),
      child: Row(
        children: [
          Semantics(
            header: true,
            child: Text(
              title,
              style: context.text.titleSmall?.copyWith(
                color: color ?? context.colors.onSurfaceVariant,
              ),
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: Space.sm),
            Text(
              '$count',
              style: context.text.labelMedium?.copyWith(
                color: context.palette.textMuted,
              ),
            ),
          ],
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}
