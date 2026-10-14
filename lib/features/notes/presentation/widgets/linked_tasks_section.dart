import 'dart:async';

import 'package:daily_mate/app/destinations.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/widgets/section_header.dart';
import 'package:daily_mate/features/notes/presentation/cubit/note_editor_cubit.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_checkbox.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_picker_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Tasks linked to the open note: tick them off, open, unlink, link more,
/// or turn the selected text into a new one.
class LinkedTasksSection extends StatelessWidget {
  const LinkedTasksSection({
    required this.tasks,
    required this.selectedText,
    super.key,
  });

  final List<Task> tasks;

  /// Current body selection, used as the new task's title.
  final String Function() selectedText;

  Future<void> _createTask(BuildContext context) async {
    final cubit = context.read<NoteEditorCubit>();
    var id = 0;
    final created = await runAction(
      context,
      () async =>
          id = await cubit.createTaskFromNote(selection: selectedText()),
      success: 'Task created from this note',
    );
    if (created && context.mounted) _open(context, id);
  }

  Future<void> _link(BuildContext context) async {
    final cubit = context.read<NoteEditorCubit>();
    final task = await showTaskPicker(context, search: cubit.searchTasks);
    if (task == null || !context.mounted) return;
    await runAction(context, () => cubit.linkTask(task));
  }

  void _open(BuildContext context, int taskId) =>
      context.go('${AppDestination.tasks.path}?task=$taskId');

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NoteEditorCubit>();
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
          'Linked tasks',
          count: tasks.isEmpty ? null : tasks.length,
          trailing: Wrap(
            spacing: Space.xs,
            children: [
              TextButton.icon(
                onPressed: () => unawaited(_link(context)),
                icon: const Icon(CupertinoIcons.link, size: IconSizes.md),
                label: const Text('Link Task'),
              ),
              TextButton.icon(
                onPressed: () => unawaited(_createTask(context)),
                icon: const Icon(CupertinoIcons.plus, size: IconSizes.md),
                label: const Text('Create Task'),
              ),
            ],
          ),
        ),
        if (tasks.isEmpty)
          Text(
            'Select text and choose Create Task to turn it into a task.',
            style: context.text.bodySmall?.copyWith(color: palette.textMuted),
          ),
        for (final task in tasks)
          Row(
            children: [
              TaskCheckbox(
                checked: task.isCompleted,
                priority: task.priority,
                label: task.title,
                onChanged: () =>
                    unawaited(runAction(context, () => cubit.toggleTask(task))),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(Radii.sm),
                  onTap: () => _open(context, task.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.xs),
                    child: Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodyMedium?.copyWith(
                        color: task.isCompleted ? palette.textMuted : null,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Unlink task',
                onPressed: () =>
                    unawaited(runAction(context, () => cubit.unlinkTask(task))),
                icon: const Icon(CupertinoIcons.xmark, size: IconSizes.sm),
              ),
            ],
          ),
      ],
    );
  }
}
