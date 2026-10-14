import 'package:daily_mate/core/ui/action_runner.dart';
import 'package:daily_mate/core/ui/widgets/confirmation_dialog.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_commands.dart';
import 'package:flutter/widgets.dart';

/// Row and menu actions bound to a page's cubit, with feedback: completing
/// offers Undo, deleting asks first, failures show a message.
class TaskListActions {
  const TaskListActions(this._context, this._commands);

  final BuildContext _context;
  final TaskCommands _commands;

  Future<void> toggle(Task task) async {
    if (task.isCompleted) {
      await runAction(_context, () => _commands.reopenTask(task.id));
      return;
    }
    await runAction(
      _context,
      () => _commands.completeTask(task.id),
      success: 'Completed ${quoted(task.title)}',
      undo: () => _commands.reopenTask(task.id),
    );
  }

  Future<void> delete(Task task) async {
    final confirmed = await showConfirmationDialog(
      _context,
      title: 'Delete task?',
      message: task.isRecurring
          ? '${quoted(task.title)} will be deleted and will stop repeating. '
                "This can't be undone."
          : "${quoted(task.title)} will be deleted. This can't be undone.",
    );
    if (!confirmed || !_context.mounted) return;
    await runAction(
      _context,
      () => _commands.deleteTask(task.id),
      success: 'Deleted ${quoted(task.title)}',
    );
  }

  Future<void> moveTo(Task task, DateTime? date) =>
      runAction(_context, () => _commands.moveTask(task, date));

  Future<void> setPriority(Task task, Priority priority) =>
      runAction(_context, () => _commands.setTaskPriority(task, priority));
}
