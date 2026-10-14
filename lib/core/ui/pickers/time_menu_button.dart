import 'dart:async';

import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/widgets/menu_picker_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Time of day as minutes after midnight; presets plus a typed entry.
class TimeMenuButton extends StatelessWidget {
  const TimeMenuButton({
    required this.minutes,
    required this.onChanged,
    super.key,
    this.allowClear = true,
    this.placeholder = 'Add time',
  });

  final int? minutes;
  final ValueChanged<int?> onChanged;
  final bool allowClear;
  final String placeholder;

  static const List<int> presets = [9 * 60, 12 * 60, 15 * 60, 18 * 60, 21 * 60];

  Future<void> _pick(BuildContext context) async {
    final current = minutes ?? 9 * 60;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) onChanged(picked.hour * 60 + picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    final minutes = this.minutes;
    return MenuPickerButton(
      icon: CupertinoIcons.clock,
      label: minutes == null
          ? placeholder
          : formatMinutesOfDay(context, minutes),
      placeholder: minutes == null,
      semanticLabel: minutes == null
          ? placeholder
          : 'Time, ${formatMinutesOfDay(context, minutes)}',
      menuChildren: [
        for (final preset in presets)
          MenuItemButton(
            onPressed: () => onChanged(preset),
            child: Text(formatMinutesOfDay(context, preset)),
          ),
        MenuItemButton(
          onPressed: () => unawaited(_pick(context)),
          child: const Text('Custom…'),
        ),
        if (allowClear && minutes != null) ...[
          const Divider(),
          MenuItemButton(
            onPressed: () => onChanged(null),
            child: const Text('Remove Time'),
          ),
        ],
      ],
    );
  }
}
