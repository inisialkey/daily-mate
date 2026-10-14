import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';

/// Task actions every task list offers (row checkbox, context menu,
/// keyboard). Failures propagate to the caller's `runAction`.
///
/// Methods end in `Task`: `package:meta` (re-exported by freezed) declares a
/// top-level `reopen` that would shadow an inherited `reopen` method.
mixin TaskCommands {
  TaskRepository get tasks;

  Future<int> createTask(TaskDraft draft) => tasks.create(draft);

  Future<void> completeTask(int id) => tasks.complete(id);

  Future<void> reopenTask(int id) => tasks.reopen(id);

  Future<void> deleteTask(int id) => tasks.delete(id);

  Future<void> moveTask(Task task, DateTime? date) =>
      tasks.update(task.id, TaskDraft.fromTask(task).copyWith(dueDate: date));

  Future<void> setTaskPriority(Task task, Priority priority) => tasks.update(
    task.id,
    TaskDraft.fromTask(task).copyWith(priority: priority),
  );
}
