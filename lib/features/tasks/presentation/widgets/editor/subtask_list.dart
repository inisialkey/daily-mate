import 'dart:async';

import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/bare_decoration.dart';
import 'package:daily_mate/core/ui/widgets/section_header.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_editor_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Checklist: tick, rename in place, delete, and add with Enter (focus stays
/// in the field for fast entry).
class SubtaskList extends StatelessWidget {
  const SubtaskList({required this.subtasks, super.key});

  final List<Subtask> subtasks;

  @override
  Widget build(BuildContext context) {
    final done = subtasks.where((s) => s.done).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          'Checklist',
          trailing: subtasks.isEmpty
              ? null
              : Text(
                  '$done of ${subtasks.length}',
                  style: context.text.labelMedium?.copyWith(
                    color: context.palette.textMuted,
                  ),
                ),
        ),
        for (final subtask in subtasks)
          _SubtaskRow(key: ValueKey(subtask.id), subtask: subtask),
        const _AddSubtaskField(),
      ],
    );
  }
}

class _SubtaskRow extends StatefulWidget {
  const _SubtaskRow({required this.subtask, super.key});

  final Subtask subtask;

  @override
  State<_SubtaskRow> createState() => _SubtaskRowState();
}

class _SubtaskRowState extends State<_SubtaskRow> {
  late final _controller = TextEditingController(text: widget.subtask.title);
  final _focus = FocusNode();
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _rename();
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(_SubtaskRow old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && _controller.text != widget.subtask.title) {
      _controller.text = widget.subtask.title;
    }
  }

  void _rename() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _controller.text = widget.subtask.title;
    } else if (text != widget.subtask.title) {
      final cubit = context.read<TaskEditorCubit>();
      unawaited(
        runAction(context, () => cubit.renameSubtask(widget.subtask.id, text)),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskEditorCubit>();
    final subtask = widget.subtask;
    final palette = context.palette;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Row(
        children: [
          Checkbox(
            value: subtask.done,
            semanticLabel: subtask.title,
            onChanged: (_) => unawaited(
              runAction(context, () => cubit.toggleSubtask(subtask)),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              style: context.text.bodyMedium?.copyWith(
                color: subtask.done ? palette.textMuted : null,
                decoration: subtask.done ? TextDecoration.lineThrough : null,
              ),
              decoration: bareDecoration(hintText: ''),
              onSubmitted: (_) => _focus.unfocus(),
            ),
          ),
          Opacity(
            opacity: _hovered || _focus.hasFocus ? 1 : 0,
            child: IconButton(
              tooltip: 'Delete item',
              onPressed: () => unawaited(
                runAction(context, () => cubit.deleteSubtask(subtask.id)),
              ),
              icon: const Icon(CupertinoIcons.xmark, size: IconSizes.sm),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddSubtaskField extends StatefulWidget {
  const _AddSubtaskField();

  @override
  State<_AddSubtaskField> createState() => _AddSubtaskFieldState();
}

class _AddSubtaskFieldState extends State<_AddSubtaskField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  Future<void> _add(String text) async {
    if (text.trim().isEmpty) return;
    final cubit = context.read<TaskEditorCubit>();
    final added = await runAction(context, () => cubit.addSubtask(text));
    if (added) _controller.clear();
    _focus.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Icon(
          CupertinoIcons.plus,
          size: IconSizes.md,
          color: context.palette.textMuted,
        ),
      ),
      Expanded(
        child: TextField(
          controller: _controller,
          focusNode: _focus,
          style: context.text.bodyMedium,
          decoration: bareDecoration(
            hintText: 'Add item',
            hintStyle: context.text.bodyMedium?.copyWith(
              color: context.palette.textMuted,
            ),
          ),
          onSubmitted: (text) => unawaited(_add(text)),
        ),
      ),
    ],
  );
}
