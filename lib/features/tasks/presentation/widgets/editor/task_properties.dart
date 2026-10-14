import 'dart:async';

import 'package:clock/clock.dart';
import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/formatting.dart';
import 'package:daily_mate/core/ui/pickers/date_menu_button.dart';
import 'package:daily_mate/core/ui/pickers/recurrence_menu_button.dart';
import 'package:daily_mate/core/ui/pickers/time_menu_button.dart';
import 'package:daily_mate/core/ui/widgets/menu_picker_button.dart';
import 'package:daily_mate/core/ui/widgets/property_row.dart';
import 'package:daily_mate/core/ui/widgets/tag_input.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:daily_mate/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_editor_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/editor/category_field.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/reminder_offset_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Due, repeat, reminder, priority, category and tags. Every change saves
/// immediately. Repeat and reminder need a date, so choosing one on an
/// undated task dates it today.
class TaskProperties extends StatelessWidget {
  const TaskProperties({
    required this.task,
    required this.categories,
    required this.tags,
    required this.notes,
    super.key,
  });

  final Task task;
  final List<String> categories;
  final List<String> tags;
  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskEditorCubit>();
    void edit(TaskDraft Function(TaskDraft draft) change) =>
        unawaited(runAction(context, () => cubit.edit(change)));
    final today = dateOnly(clock.now());
    final defaultMinutes = context.select<SettingsCubit, int>(
      (c) => c.state.defaultReminderMinutes,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PropertyRow(
          icon: CupertinoIcons.calendar,
          label: 'Due',
          child: Wrap(
            children: [
              DateMenuButton(
                date: task.dueDate,
                highlightPast: !task.isCompleted,
                onChanged: (date) => edit((d) => d.copyWith(dueDate: date)),
              ),
              if (task.dueDate != null)
                TimeMenuButton(
                  minutes: task.dueMinutes,
                  onChanged: (minutes) =>
                      edit((d) => d.copyWith(dueMinutes: minutes)),
                ),
            ],
          ),
        ),
        PropertyRow(
          icon: CupertinoIcons.repeat,
          label: 'Repeat',
          child: RecurrenceMenuButton(
            rule: task.recurrence,
            onChanged: (rule) => edit(
              (d) => d.copyWith(
                recurrence: rule,
                dueDate: d.dueDate ?? (rule == null ? null : today),
              ),
            ),
          ),
        ),
        PropertyRow(
          icon: CupertinoIcons.bell,
          label: 'Reminder',
          child: ReminderOffsetButton(
            offset: task.reminderOffsetMinutes,
            onChanged: (offset) => edit(
              (d) => d.copyWith(
                reminderOffsetMinutes: offset,
                dueDate: d.dueDate ?? (offset == null ? null : today),
              ),
            ),
          ),
        ),
        if (task.reminderOffsetMinutes != null && task.dueMinutes == null)
          Padding(
            padding: const EdgeInsets.only(left: 104 + Space.sm),
            child: Text(
              'No due time, so it counts from '
              '${formatMinutesOfDay(context, defaultMinutes)} '
              '(change in Settings).',
              style: context.text.bodySmall?.copyWith(
                color: context.palette.textMuted,
              ),
            ),
          ),
        PropertyRow(
          icon: CupertinoIcons.flag,
          label: 'Priority',
          child: SegmentedButton<Priority>(
            showSelectedIcon: false,
            segments: [
              for (final p in Priority.values)
                ButtonSegment(
                  value: p,
                  label: Text(p == Priority.medium ? 'Med' : p.label),
                  tooltip: '${p.label} priority',
                ),
            ],
            selected: {task.priority},
            onSelectionChanged: (selection) =>
                edit((d) => d.copyWith(priority: selection.first)),
          ),
        ),
        PropertyRow(
          icon: CupertinoIcons.folder,
          label: 'Category',
          child: CategoryField(
            value: task.category,
            suggestions: categories,
            onChanged: (category) =>
                edit((d) => d.copyWith(category: category)),
          ),
        ),
        PropertyRow(
          icon: CupertinoIcons.doc_text,
          label: 'Note',
          child: _NoteLink(
            noteId: task.noteId,
            notes: notes,
            onChanged: (id) => edit((d) => d.copyWith(noteId: id)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: Space.xs),
          child: PropertyRow(
            icon: CupertinoIcons.number,
            label: 'Tags',
            child: TagInput(
              tags: task.tags,
              suggestions: tags,
              onChanged: (tags) => edit((d) => d.copyWith(tags: tags)),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoteLink extends StatelessWidget {
  const _NoteLink({
    required this.noteId,
    required this.notes,
    required this.onChanged,
  });

  final int? noteId;
  final List<Note> notes;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final id = noteId;
    final linked = notes.where((n) => n.id == id).firstOrNull;
    final label = id == null
        ? 'None'
        : (linked?.displayTitle ?? 'Archived note');
    return Row(
      children: [
        Flexible(
          child: MenuPickerButton(
            label: label,
            placeholder: id == null,
            semanticLabel: 'Linked note, $label',
            menuChildren: [
              MenuItemButton(
                onPressed: () => onChanged(null),
                child: const Text('None'),
              ),
              if (notes.isNotEmpty) const Divider(),
              for (final note in notes.take(30))
                MenuItemButton(
                  trailingIcon: note.id == id
                      ? const Icon(CupertinoIcons.checkmark_alt)
                      : null,
                  onPressed: () => onChanged(note.id),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 260),
                    child: Text(
                      note.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (id != null)
          IconButton(
            tooltip: 'Open note',
            onPressed: () =>
                context.go('${AppDestination.notes.path}?note=$id'),
            icon: const Icon(
              CupertinoIcons.arrow_up_right_square,
              size: IconSizes.md,
            ),
          ),
      ],
    );
  }
}
