import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// One sidebar row: destination or action. Collapsed rows show the icon with
/// a tooltip that names the item and its shortcut.
class SidebarItem extends StatelessWidget {
  const SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.showLabel,
    super.key,
    this.selected = false,
    this.shortcut,
    this.badge,
    this.caption,
    this.emphasized = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showLabel;
  final bool selected;
  final String? shortcut;
  final int? badge;

  /// Short trailing text, e.g. the next prayer time.
  final String? caption;

  /// Primary call to action (New Task).
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final palette = context.palette;
    final badge = this.badge;
    final caption = this.caption;
    final foreground = emphasized ? colors.primary : colors.onSurface;
    final iconColor = selected || emphasized
        ? colors.primary
        : colors.onSurfaceVariant;

    final row = SizedBox(
      height: 34,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: showLabel ? Space.sm + 2 : 0,
        ),
        child: Row(
          mainAxisAlignment: showLabel
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Icon(icon, size: IconSizes.lg, color: iconColor),
            if (showLabel) ...[
              const SizedBox(width: Space.sm + 2),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyMedium?.copyWith(
                    color: foreground,
                    fontWeight: selected || emphasized
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
              if (caption != null)
                Text(
                  caption,
                  style: context.text.labelMedium?.copyWith(
                    color: palette.textMuted,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                )
              else if (badge != null && badge > 0)
                Text(
                  '$badge',
                  style: context.text.labelMedium?.copyWith(
                    color: palette.textMuted,
                  ),
                ),
            ],
          ],
        ),
      ),
    );

    final shortcut = this.shortcut;
    final tooltip = shortcut == null ? label : '$label  $shortcut';
    return Semantics(
      button: true,
      selected: selected,
      label: badge != null && badge > 0 ? '$label, $badge' : label,
      excludeSemantics: true,
      child: Tooltip(
        message: tooltip,
        waitDuration: Duration(milliseconds: showLabel ? 1200 : 300),
        child: Material(
          color: selected ? palette.selection : Colors.transparent,
          borderRadius: BorderRadius.circular(Radii.md),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Radii.md),
            child: row,
          ),
        ),
      ),
    );
  }
}
