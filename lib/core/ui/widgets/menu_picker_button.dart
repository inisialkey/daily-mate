import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Compact button showing the current value; opens [menuChildren].
class MenuPickerButton extends StatelessWidget {
  const MenuPickerButton({
    required this.label,
    required this.menuChildren,
    super.key,
    this.icon,
    this.placeholder = false,
    this.semanticLabel,
    this.color,
  });

  final String label;
  final List<Widget> menuChildren;
  final IconData? icon;

  /// Muted styling for "Add date" style empty values.
  final bool placeholder;
  final String? semanticLabel;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground =
        color ?? (placeholder ? palette.textMuted : context.colors.onSurface);
    final icon = this.icon;
    return MenuAnchor(
      menuChildren: menuChildren,
      builder: (context, controller, _) => Semantics(
        label: semanticLabel,
        button: true,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: foreground,
            textStyle: context.text.bodyMedium,
            padding: const EdgeInsets.symmetric(horizontal: Space.sm),
            minimumSize: const Size(0, 30),
          ),
          onPressed: () =>
              controller.isOpen ? controller.close() : controller.open(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: IconSizes.md, color: foreground),
                const SizedBox(width: Space.xs + 2),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: Space.xs),
              Icon(
                CupertinoIcons.chevron_down,
                size: 10,
                color: palette.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
