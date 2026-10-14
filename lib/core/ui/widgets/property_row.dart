import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// "Label: control" line in inspectors and editors.
class PropertyRow extends StatelessWidget {
  const PropertyRow({
    required this.icon,
    required this.label,
    required this.child,
    super.key,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final muted = context.palette.textMuted;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.xxs),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            child: Row(
              children: [
                Icon(icon, size: IconSizes.md, color: muted),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodyMedium?.copyWith(color: muted),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(alignment: Alignment.centerLeft, child: child),
          ),
        ],
      ),
    );
  }
}
