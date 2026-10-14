import 'package:flutter/material.dart';

/// Material 3's switch sized for a dense desktop row.
class CompactSwitch extends StatelessWidget {
  const CompactSwitch({
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    toggled: value,
    excludeSemantics: true,
    child: Transform.scale(
      scale: 0.72,
      child: Switch(value: value, onChanged: onChanged),
    ),
  );
}
