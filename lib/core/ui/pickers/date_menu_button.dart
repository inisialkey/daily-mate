import 'dart:async';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/widgets/menu_picker_button.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Date with quick choices (Today, Tomorrow, Next Week) and a calendar.
class DateMenuButton extends StatelessWidget {
  const DateMenuButton({
    required this.date,
    required this.onChanged,
    super.key,
    this.allowClear = true,
    this.placeholder = 'Add date',
    this.highlightPast = false,
  });

  final DateTime? date;
  final ValueChanged<DateTime?> onChanged;
  final bool allowClear;
  final String placeholder;

  /// Show past dates in the error color (overdue).
  final bool highlightPast;

  Future<void> _pick(BuildContext context, DateTime today) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? today,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 10, 12, 31),
    );
    if (picked != null) onChanged(dateOnly(picked));
  }

  @override
  Widget build(BuildContext context) {
    final today = dateOnly(clock.now());
    final date = this.date;
    final past = highlightPast && date != null && date.isBefore(today);
    return MenuPickerButton(
      icon: CupertinoIcons.calendar,
      label: date == null ? placeholder : formatRelativeDay(date, today),
      placeholder: date == null,
      color: past ? Theme.of(context).colorScheme.error : null,
      semanticLabel: date == null
          ? placeholder
          : 'Date, ${formatLongDate(date)}',
      menuChildren: [
        for (final (label, value) in [
          ('Today', today),
          ('Tomorrow', addDays(today, 1)),
          ('Next Week', addDays(startOfWeek(today), 7)),
        ])
          MenuItemButton(
            onPressed: () => onChanged(value),
            child: Text(label),
          ),
        MenuItemButton(
          onPressed: () => unawaited(_pick(context, today)),
          child: const Text('Pick a Date…'),
        ),
        if (allowClear && date != null) ...[
          const Divider(),
          MenuItemButton(
            onPressed: () => onChanged(null),
            child: const Text('Remove Date'),
          ),
        ],
      ],
    );
  }
}
