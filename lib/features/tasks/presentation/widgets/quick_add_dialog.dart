import 'dart:async';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/bare_decoration.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/pickers/date_menu_button.dart';
import 'package:daily_mate/core/ui/pickers/recurrence_menu_button.dart';
import 'package:daily_mate/core/ui/pickers/time_menu_button.dart';
import 'package:daily_mate/core/ui/widgets/menu_picker_button.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/quick_add_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ⌘N: capture a task without opening the full editor. Resolves to the new
/// task's id, or null when cancelled.
Future<int?> showQuickAddDialog(BuildContext context, {DateTime? date}) =>
    showDialog<int>(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => sl<QuickAddCubit>(),
        child: QuickAddDialog(date: date),
      ),
    );

class QuickAddDialog extends StatefulWidget {
  const QuickAddDialog({super.key, this.date});

  final DateTime? date;

  @override
  State<QuickAddDialog> createState() => _QuickAddDialogState();
}

class _QuickAddDialogState extends State<QuickAddDialog> {
  final _title = TextEditingController();
  late DateTime? _date = widget.date;
  int? _minutes;
  Priority _priority = Priority.none;
  RecurrenceRule? _recurrence;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _title.text.trim();
    if (title.isEmpty || _saving) return;
    setState(() => _saving = true);
    final cubit = context.read<QuickAddCubit>();
    final navigator = Navigator.of(context);
    var id = 0;
    final date = _date;
    final where = date == null
        ? ''
        : ' to ${formatRelativeDay(date, dateOnly(clock.now()))}';
    final added = await runAction(
      context,
      () async => id = await cubit.createTask(
        TaskDraft(
          title: title,
          dueDate: date,
          dueMinutes: _minutes,
          priority: _priority,
          recurrence: _recurrence,
        ),
      ),
      success: 'Added ${quoted(title)}$where',
    );
    if (!mounted) return;
    if (added) {
      navigator.pop(id);
    } else {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Dialog(
      child: SizedBox(
        width: 560,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.xl,
            Space.lg,
            Space.lg,
            Space.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    CupertinoIcons.circle,
                    size: IconSizes.lg,
                    color: palette.textMuted,
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: TextField(
                      controller: _title,
                      autofocus: true,
                      style: context.text.titleMedium,
                      decoration: bareDecoration(
                        hintText: 'New task',
                        hintStyle: context.text.titleMedium?.copyWith(
                          color: palette.textMuted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onSubmitted: (_) => unawaited(_submit()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.lg),
              Wrap(
                spacing: Space.xs,
                runSpacing: Space.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  DateMenuButton(
                    date: _date,
                    placeholder: 'No date',
                    onChanged: (date) => setState(() {
                      _date = date;
                      if (date == null) {
                        _minutes = null;
                        _recurrence = null;
                      }
                    }),
                  ),
                  if (_date != null)
                    TimeMenuButton(
                      minutes: _minutes,
                      onChanged: (m) => setState(() => _minutes = m),
                    ),
                  MenuPickerButton(
                    icon: CupertinoIcons.flag,
                    label: _priority == Priority.none
                        ? 'Priority'
                        : _priority.label,
                    placeholder: _priority == Priority.none,
                    menuChildren: [
                      for (final p in Priority.values.reversed)
                        MenuItemButton(
                          onPressed: () => setState(() => _priority = p),
                          child: Text(p.label),
                        ),
                    ],
                  ),
                  RecurrenceMenuButton(
                    rule: _recurrence,
                    onChanged: (rule) => setState(() {
                      _recurrence = rule;
                      if (rule != null) _date ??= dateOnly(clock.now());
                    }),
                  ),
                ],
              ),
              const SizedBox(height: Space.lg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '⏎ to add · Esc to cancel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall?.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: Space.sm),
                  ValueListenableBuilder(
                    valueListenable: _title,
                    builder: (context, value, _) => FilledButton(
                      onPressed: value.text.trim().isEmpty || _saving
                          ? null
                          : () => unawaited(_submit()),
                      child: const Text('Add Task'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
