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
import 'package:daily_mate/features/tasks/domain/quick_add_parser.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/quick_add_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ⌘N: capture a task without opening the full editor. The title may carry
/// its date, time and priority (`besok 14:00 !1`); the pickers show what was
/// recognized. Resolves to the new task's id, or null when cancelled.
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

  // What the pickers set. Tokens typed in the title take precedence until
  // the user picks that field: the picker removes the token it replaces and
  // from then on owns the field, so a later word of that kind stays text.
  late DateTime? _date = widget.date;
  int? _minutes;
  Priority _priority = Priority.none;
  RecurrenceRule? _recurrence;
  bool _saving = false;
  QuickAddParse _parsed = const QuickAddParse(title: '');
  bool _datePicked = false;
  bool _timePicked = false;
  bool _priorityPicked = false;

  DateTime get _today => dateOnly(clock.now());

  /// A time without a day is for the picked day, or today; past midnight
  /// ("jam 12 malam") it is the day after, unless the user picked the day.
  DateTime? get _effectiveDate => _datePicked && _date != null
      ? _date
      : _parsed.dueDate(_date ?? (_parsed.minutes == null ? null : _today));
  int? get _effectiveMinutes => _parsed.minutes ?? _minutes;
  Priority get _effectivePriority => _parsed.priority ?? _priority;

  @override
  void initState() {
    super.initState();
    _title.addListener(_reparse);
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _reparse() {
    final parsed = parseQuickAdd(
      _title.text,
      today: _today,
      dates: !_datePicked,
      times: !_timePicked,
      priorities: !_priorityPicked,
    );
    setState(() => _parsed = parsed);
  }

  /// Cuts the named kinds of token out of the title, keeping any word the
  /// other tokens share with them ("jam 8 malam minggu"), and re-parses it.
  void _dropTokens({
    bool date = false,
    bool time = false,
    bool priority = false,
  }) {
    final p = _parsed;
    final drop = [
      if (date) p.dateRange,
      if (time) p.timeRange,
      if (priority) p.priorityRange,
    ].nonNulls;
    final keep = [
      if (!date) p.dateRange,
      if (!time) p.timeRange,
      if (!priority) p.priorityRange,
    ].nonNulls;
    final text = drop.isEmpty
        ? _title.text
        : removeTokens(_title.text, drop, keep: keep);
    if (text == _title.text) {
      _reparse();
      return;
    }
    _title.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// The day for the time and repeat pickers to keep once the typed words
  /// are gone: the typed day, else the picked one, else today. Without the
  /// after-midnight shift, which belongs to the typed time ("jam 12 malam").
  void _keepDay() => _date = _parsed.date ?? _date ?? _today;

  Future<void> _submit() async {
    final title = _parsed.title.trim();
    if (title.isEmpty || _saving) return;
    setState(() => _saving = true);
    final cubit = context.read<QuickAddCubit>();
    final navigator = Navigator.of(context);
    var id = 0;
    final date = _effectiveDate;
    final where = date == null ? '' : ' to ${formatRelativeDay(date, _today)}';
    final added = await runAction(
      context,
      () async => id = await cubit.createTask(
        TaskDraft(
          title: title,
          dueDate: date,
          dueMinutes: _effectiveMinutes,
          priority: _effectivePriority,
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
    final date = _effectiveDate;
    final priority = _effectivePriority;
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
                        hintText: 'New task, e.g. Review PR besok 14:00 !1',
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
                    date: date,
                    placeholder: 'No date',
                    onChanged: (date) {
                      setState(() {
                        _date = date;
                        _datePicked = true;
                        if (date == null) {
                          _minutes = null;
                          _recurrence = null;
                        }
                      });
                      // A time needs a day, so it goes with the date; a
                      // time typed later still counts (for today).
                      _dropTokens(date: true, time: date == null);
                    },
                  ),
                  if (date != null)
                    TimeMenuButton(
                      minutes: _effectiveMinutes,
                      onChanged: (m) {
                        setState(() {
                          _keepDay();
                          _minutes = m;
                          _timePicked = true;
                        });
                        _dropTokens(time: true);
                      },
                    ),
                  MenuPickerButton(
                    icon: CupertinoIcons.flag,
                    label: priority == Priority.none
                        ? 'Priority'
                        : priority.label,
                    placeholder: priority == Priority.none,
                    menuChildren: [
                      for (final p in Priority.values.reversed)
                        MenuItemButton(
                          onPressed: () {
                            setState(() {
                              _priority = p;
                              _priorityPicked = true;
                            });
                            _dropTokens(priority: true);
                          },
                          child: Text(p.label),
                        ),
                    ],
                  ),
                  RecurrenceMenuButton(
                    rule: _recurrence,
                    onChanged: (rule) => setState(() {
                      _recurrence = rule;
                      // A repeat needs a day, even if the typed word that
                      // gave it is deleted later.
                      if (rule != null) _keepDay();
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
