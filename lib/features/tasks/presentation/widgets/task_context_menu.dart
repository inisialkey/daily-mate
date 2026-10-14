import 'package:clock/clock.dart';
import 'package:daily_mate/core/theme/app_palette.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/presentation/widgets/task_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Right-click menu for a task row.
class TaskContextMenu extends StatefulWidget {
  const TaskContextMenu({
    required this.task,
    required this.actions,
    required this.onOpen,
    required this.child,
    super.key,
  });

  final Task task;
  final TaskListActions actions;
  final VoidCallback onOpen;
  final Widget child;

  @override
  State<TaskContextMenu> createState() => _TaskContextMenuState();
}

class _TaskContextMenuState extends State<TaskContextMenu> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final actions = widget.actions;
    final today = dateOnly(clock.now());
    final error = context.colors.error;
    return MenuAnchor(
      controller: _controller,
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(CupertinoIcons.checkmark_circle),
          onPressed: () => actions.toggle(task),
          child: Text(task.isCompleted ? 'Mark as Not Done' : 'Complete'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(CupertinoIcons.square_pencil),
          onPressed: widget.onOpen,
          child: const Text('Open'),
        ),
        const Divider(),
        SubmenuButton(
          leadingIcon: const Icon(CupertinoIcons.calendar),
          menuChildren: [
            for (final (label, date) in [
              ('Today', today),
              ('Tomorrow', addDays(today, 1)),
              ('Next Week', addDays(startOfWeek(today), 7)),
              ('No Date', null),
            ])
              MenuItemButton(
                onPressed: () => actions.moveTo(task, date),
                child: Text(label),
              ),
          ],
          child: const Text('Due Date'),
        ),
        SubmenuButton(
          leadingIcon: const Icon(CupertinoIcons.flag),
          menuChildren: [
            for (final priority in Priority.values.reversed)
              MenuItemButton(
                trailingIcon: priority == task.priority
                    ? const Icon(CupertinoIcons.checkmark_alt)
                    : null,
                onPressed: () => actions.setPriority(task, priority),
                child: Text(priority.label),
              ),
          ],
          child: const Text('Priority'),
        ),
        const Divider(),
        MenuItemButton(
          leadingIcon: Icon(CupertinoIcons.trash, color: error),
          onPressed: () => actions.delete(task),
          child: Text('Delete…', style: TextStyle(color: error)),
        ),
      ],
      child: GestureDetector(
        // Right-click only: without this, assistive tech would see a
        // second, unlabeled tap target that does nothing.
        excludeFromSemantics: true,
        onSecondaryTapUp: (details) =>
            _controller.open(position: details.localPosition),
        child: widget.child,
      ),
    );
  }
}
