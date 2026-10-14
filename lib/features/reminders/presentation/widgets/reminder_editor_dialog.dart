import 'package:clock/clock.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/pickers/date_menu_button.dart';
import 'package:daily_mate/core/ui/pickers/recurrence_menu_button.dart';
import 'package:daily_mate/core/ui/pickers/time_menu_button.dart';
import 'package:daily_mate/core/ui/widgets/property_row.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/reminders/domain/reminder.dart';
import 'package:daily_mate/features/reminders/domain/reminder_draft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Create or edit a reminder (ReminderEditor). Resolves to the draft, or
/// null when cancelled.
Future<ReminderDraft?> showReminderEditor(
  BuildContext context, {
  Reminder? existing,
}) => showDialog<ReminderDraft>(
  context: context,
  builder: (_) => _ReminderEditor(existing: existing),
);

class _ReminderEditor extends StatefulWidget {
  const _ReminderEditor({this.existing});

  final Reminder? existing;

  @override
  State<_ReminderEditor> createState() => _ReminderEditorState();
}

class _ReminderEditorState extends State<_ReminderEditor> {
  late final Reminder? _existing = widget.existing;
  late final _title = TextEditingController(text: _existing?.title ?? '');
  late final _notes = TextEditingController(text: _existing?.notes ?? '');
  late DateTime _date = _existing?.date ?? _defaultStart().date;
  late int _minutes = _existing?.minutes ?? _defaultStart().minutes;
  late RecurrenceRule? _recurrence = _existing?.recurrence;
  String? _error;

  /// The next full hour.
  static ({DateTime date, int minutes}) _defaultStart() {
    final next = clock.now().add(const Duration(hours: 1));
    return (date: dateOnly(next), minutes: next.hour * 60);
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (_title.text.trim().isEmpty) {
      setState(() => _error = 'Give the reminder a title.');
      return;
    }
    final timingChanged =
        _existing == null ||
        _date != _existing.date ||
        _minutes != _existing.minutes ||
        _recurrence != _existing.recurrence;
    final firstAt = atMinutes(_date, _minutes);
    if (timingChanged && _recurrence == null && !firstAt.isAfter(clock.now())) {
      setState(() => _error = 'Pick a time in the future.');
      return;
    }
    Navigator.of(context).pop(
      ReminderDraft(
        title: _title.text,
        notes: _notes.text,
        date: _date,
        minutes: _minutes,
        recurrence: _recurrence,
        enabled: _existing?.enabled ?? true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    return AlertDialog(
      title: Text(_existing == null ? 'New Reminder' : 'Edit Reminder'),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _title,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Title'),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: Space.md),
            TextField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: Space.md),
            PropertyRow(
              icon: CupertinoIcons.calendar,
              label: 'Date',
              child: DateMenuButton(
                date: _date,
                allowClear: false,
                onChanged: (date) => setState(() => _date = date ?? _date),
              ),
            ),
            PropertyRow(
              icon: CupertinoIcons.clock,
              label: 'Time',
              child: TimeMenuButton(
                minutes: _minutes,
                allowClear: false,
                onChanged: (m) => setState(() => _minutes = m ?? _minutes),
              ),
            ),
            PropertyRow(
              icon: CupertinoIcons.repeat,
              label: 'Repeat',
              child: RecurrenceMenuButton(
                rule: _recurrence,
                onChanged: (rule) => setState(() => _recurrence = rule),
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: Space.sm),
              Text(
                error,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
