import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/theme/tokens.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_actions.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_checkbox.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_context_menu.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_meta.dart';
import 'package:flutter/material.dart';

class TaskRow extends StatelessWidget {
  const TaskRow({
    required this.task,
    required this.now,
    required this.actions,
    required this.onOpen,
    super.key,
    this.selected = false,
    this.showDate = true,
  });

  final Task task;
  final DateTime now;
  final TaskListActions actions;
  final VoidCallback onOpen;
  final bool selected;

  /// False in day-grouped lists, where the section already names the day.
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final done = task.isCompleted;
    return TaskContextMenu(
      task: task,
      actions: actions,
      onOpen: onOpen,
      child: Material(
        color: selected ? palette.selection : Colors.transparent,
        borderRadius: BorderRadius.circular(Radii.md),
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(Radii.md),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.xs,
              Space.xxs,
              Space.sm,
              Space.xxs,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskCheckbox(
                  checked: done,
                  priority: task.priority,
                  label: task.title,
                  onChanged: () => actions.toggle(task),
                ),
                const SizedBox(width: Space.xs),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.bodyMedium?.copyWith(
                            color: done ? palette.textMuted : null,
                            decoration: done
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: palette.textMuted,
                          ),
                        ),
                        TaskMeta(task: task, now: now, showDate: showDate),
                      ],
                    ),
                  ),
                ),
                if (!done) PriorityFlag(task.priority),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
