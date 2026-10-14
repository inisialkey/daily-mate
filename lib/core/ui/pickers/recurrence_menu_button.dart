import 'dart:async';

import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/ui/pickers/recurrence_dialog.dart';
import 'package:daily_mate/core/ui/recurrence_label.dart';
import 'package:daily_mate/core/ui/widgets/menu_picker_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecurrenceMenuButton extends StatelessWidget {
  const RecurrenceMenuButton({
    required this.rule,
    required this.onChanged,
    super.key,
  });

  final RecurrenceRule? rule;
  final ValueChanged<RecurrenceRule?> onChanged;

  Future<void> _custom(BuildContext context) async {
    final picked = await showRecurrenceDialog(context, initial: rule);
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final rule = this.rule;
    return MenuPickerButton(
      icon: CupertinoIcons.repeat,
      label: rule == null ? 'Never' : recurrenceLabel(rule),
      placeholder: rule == null,
      semanticLabel: rule == null
          ? 'Repeat, never'
          : 'Repeat, ${recurrenceLabel(rule)}',
      menuChildren: [
        MenuItemButton(
          onPressed: () => onChanged(null),
          child: const Text('Never'),
        ),
        const Divider(),
        for (final (label, value) in [
          ('Every Day', RecurrenceRule.daily),
          ('Every Weekday', RecurrenceRule.weekdaysOnly),
          ('Every Week', RecurrenceRule.weekly),
          ('Every Month', RecurrenceRule.monthly),
          ('Every Year', RecurrenceRule.yearly),
        ])
          MenuItemButton(
            onPressed: () => onChanged(value),
            child: Text(label),
          ),
        const Divider(),
        MenuItemButton(
          onPressed: () => unawaited(_custom(context)),
          child: const Text('Custom…'),
        ),
      ],
    );
  }
}
