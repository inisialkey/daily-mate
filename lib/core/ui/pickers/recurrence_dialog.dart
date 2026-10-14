import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/pickers/date_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// "Every N days/weeks/months/years", weekdays for weekly rules, optional
/// end date. Resolves to null when cancelled.
Future<RecurrenceRule?> showRecurrenceDialog(
  BuildContext context, {
  RecurrenceRule? initial,
}) => showDialog<RecurrenceRule>(
  context: context,
  builder: (_) => _RecurrenceDialog(initial ?? RecurrenceRule.weekly),
);

class _RecurrenceDialog extends StatefulWidget {
  const _RecurrenceDialog(this.initial);

  final RecurrenceRule initial;

  @override
  State<_RecurrenceDialog> createState() => _RecurrenceDialogState();
}

class _RecurrenceDialogState extends State<_RecurrenceDialog> {
  late RecurrenceRule _rule = widget.initial;
  late final _interval = TextEditingController(
    text: '${widget.initial.interval}',
  );

  static const Map<RecurrenceFrequency, String> _units = {
    RecurrenceFrequency.daily: 'days',
    RecurrenceFrequency.weekly: 'weeks',
    RecurrenceFrequency.monthly: 'months',
    RecurrenceFrequency.yearly: 'years',
  };
  static const List<String> _dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const List<String> _dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void dispose() {
    _interval.dispose();
    super.dispose();
  }

  void _toggleDay(int day) {
    final days = {..._rule.weekdays};
    if (!days.remove(day)) days.add(day);
    setState(() => _rule = _rule.copyWith(weekdays: days));
  }

  @override
  Widget build(BuildContext context) {
    final weekly = _rule.frequency == RecurrenceFrequency.weekly;
    return AlertDialog(
      title: const Text('Repeat'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Every'),
                const SizedBox(width: Space.sm),
                SizedBox(
                  width: 64,
                  child: TextField(
                    controller: _interval,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: const InputDecoration(
                      semanticCounterText: 'Interval',
                    ),
                    onChanged: (text) => setState(
                      () => _rule = _rule.copyWith(
                        interval: (int.tryParse(text) ?? 1).clamp(1, 999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Space.sm),
                DropdownButton<RecurrenceFrequency>(
                  value: _rule.frequency,
                  underline: const SizedBox.shrink(),
                  items: [
                    for (final entry in _units.entries)
                      DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                  ],
                  onChanged: (frequency) => setState(
                    () => _rule = _rule.copyWith(
                      frequency: frequency ?? _rule.frequency,
                      weekdays: const {},
                    ),
                  ),
                ),
              ],
            ),
            if (weekly) ...[
              const SizedBox(height: Space.lg),
              const Text('On'),
              const SizedBox(height: Space.sm),
              Wrap(
                spacing: Space.xs,
                children: [
                  for (var day = 1; day <= 7; day++)
                    Tooltip(
                      message: _dayNames[day - 1],
                      child: FilterChip(
                        label: Text(_dayLetters[day - 1]),
                        selected: _rule.weekdays.contains(day),
                        showCheckmark: false,
                        onSelected: (_) => _toggleDay(day),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Space.xs),
              Text(
                'No day selected repeats on the day of the first date.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: Space.lg),
            Row(
              children: [
                const Text('Ends'),
                const SizedBox(width: Space.sm),
                DateMenuButton(
                  date: _rule.until,
                  placeholder: 'Never',
                  onChanged: (until) =>
                      setState(() => _rule = _rule.copyWith(until: until)),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_rule),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
