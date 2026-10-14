import 'package:daily_mate/core/ui/widgets/menu_picker_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// How long before a task's due time its reminder fires.
class ReminderOffsetButton extends StatelessWidget {
  const ReminderOffsetButton({
    required this.offset,
    required this.onChanged,
    super.key,
  });

  final int? offset;
  final ValueChanged<int?> onChanged;

  static const List<int> options = [0, 5, 15, 30, 60, 24 * 60];

  static String label(int offset) => switch (offset) {
    0 => 'At due time',
    < 60 => '$offset min before',
    60 => '1 hour before',
    1440 => '1 day before',
    _ when offset % 60 == 0 => '${offset ~/ 60} hours before',
    _ => '${offset ~/ 60} h ${offset % 60} min before',
  };

  @override
  Widget build(BuildContext context) {
    final offset = this.offset;
    return MenuPickerButton(
      icon: CupertinoIcons.bell,
      label: offset == null ? 'None' : label(offset),
      placeholder: offset == null,
      semanticLabel: offset == null
          ? 'Reminder, none'
          : 'Reminder, ${label(offset)}',
      menuChildren: [
        MenuItemButton(
          onPressed: () => onChanged(null),
          child: const Text('None'),
        ),
        const Divider(),
        for (final option in options)
          MenuItemButton(
            onPressed: () => onChanged(option),
            child: Text(label(option)),
          ),
      ],
    );
  }
}
