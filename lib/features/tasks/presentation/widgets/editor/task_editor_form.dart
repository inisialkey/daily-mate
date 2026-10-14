import 'dart:async';

import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/bare_decoration.dart';
import 'package:daily_mate/core/ui/widgets/confirmation_dialog.dart';
import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_editor_cubit.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/editor/subtask_list.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/editor/task_properties.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TaskEditorForm extends StatefulWidget {
  const TaskEditorForm({
    required this.task,
    required this.categories,
    required this.tags,
    required this.notes,
    required this.onClose,
    super.key,
  });

  final Task task;
  final List<String> categories;
  final List<String> tags;
  final List<Note> notes;
  final VoidCallback onClose;

  @override
  State<TaskEditorForm> createState() => _TaskEditorFormState();
}

class _TaskEditorFormState extends State<TaskEditorForm> {
  late final _title = TextEditingController(text: widget.task.title);
  late final _notes = TextEditingController(text: widget.task.notes);
  final _titleFocus = FocusNode();
  final _notesFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Leaving an emptied title restores the saved one.
    _titleFocus.addListener(() {
      if (!_titleFocus.hasFocus && _title.text.trim().isEmpty) {
        _title.text = widget.task.title;
      }
    });
  }

  @override
  void didUpdateWidget(TaskEditorForm old) {
    super.didUpdateWidget(old);
    // Saved values flow back from the database; never overwrite a field
    // the user is typing in.
    if (!_titleFocus.hasFocus && _title.text != widget.task.title) {
      _title.text = widget.task.title;
    }
    if (!_notesFocus.hasFocus && _notes.text != widget.task.notes) {
      _notes.text = widget.task.notes;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    _titleFocus.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final task = widget.task;
    final cubit = context.read<TaskEditorCubit>();
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete task?',
      message: "${quoted(task.title)} will be deleted. This can't be undone.",
    );
    if (!confirmed || !mounted) return;
    await runAction(
      context,
      () => cubit.deleteTask(task.id),
      success: 'Deleted ${quoted(task.title)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskEditorCubit>();
    final task = widget.task;
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.md,
            Space.sm,
            Space.sm,
            0,
          ),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () =>
                    unawaited(runAction(context, cubit.toggleComplete)),
                icon: Icon(
                  task.isCompleted
                      ? CupertinoIcons.checkmark_circle_fill
                      : CupertinoIcons.circle,
                  size: IconSizes.lg,
                ),
                label: Text(task.isCompleted ? 'Completed' : 'Mark Complete'),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Delete task',
                onPressed: () => unawaited(_delete()),
                icon: const Icon(CupertinoIcons.trash),
              ),
              IconButton(
                tooltip: 'Close  Esc',
                onPressed: widget.onClose,
                icon: const Icon(CupertinoIcons.xmark),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.xl,
              Space.md,
              Space.xl,
              Space.xl,
            ),
            children: [
              TextField(
                controller: _title,
                focusNode: _titleFocus,
                maxLines: null,
                style: context.text.titleLarge?.copyWith(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
                decoration: bareDecoration(hintText: 'Title'),
                onChanged: cubit.setTitle,
              ),
              const SizedBox(height: Space.md),
              TextField(
                controller: _notes,
                focusNode: _notesFocus,
                maxLines: null,
                minLines: 2,
                style: context.text.bodyMedium,
                decoration: bareDecoration(
                  hintText: 'Notes',
                  hintStyle: context.text.bodyMedium?.copyWith(
                    color: palette.textMuted,
                  ),
                ),
                onChanged: cubit.setNotes,
              ),
              const SizedBox(height: Space.lg),
              const Divider(),
              const SizedBox(height: Space.sm),
              TaskProperties(
                task: task,
                categories: widget.categories,
                tags: widget.tags,
                notes: widget.notes,
              ),
              const SizedBox(height: Space.sm),
              const Divider(),
              const SizedBox(height: Space.sm),
              SubtaskList(subtasks: task.subtasks),
              const SizedBox(height: Space.xl),
              Text(
                'Created ${_stamp(task.createdAt)} · '
                'Edited ${_stamp(task.updatedAt)}',
                style: context.text.bodySmall?.copyWith(
                  color: palette.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _stamp(DateTime time) => DateFormat('d MMM y, HH:mm').format(time);
}
