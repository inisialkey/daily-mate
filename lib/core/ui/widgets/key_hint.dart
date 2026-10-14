import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Keyboard shortcut hint such as "⌘K". Decorative: the control it sits in
/// carries the accessible label.
class KeyHint extends StatelessWidget {
  const KeyHint(this.keys, {super.key});

  final String keys;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: Space.xs + 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.sm - 2),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Text(
        keys,
        style: context.text.labelSmall?.copyWith(
          color: context.palette.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
