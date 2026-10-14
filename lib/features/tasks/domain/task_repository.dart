import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';

abstract interface class TaskRepository {
  /// Emits now and after every change to tasks, subtasks or tags.
  Stream<List<Task>> watchTasks(TaskFilter filter);

  Future<List<Task>> tasks(TaskFilter filter);

  /// Emits null once the task is deleted.
  Stream<Task?> watchTask(int id);

  Future<Task?> task(int id);

  Future<int> create(TaskDraft draft);

  Future<void> update(int id, TaskDraft draft);

  Future<void> delete(int id);

  /// Idempotent. A recurring task spawns its next occurrence exactly once,
  /// however often this occurrence is completed and reopened.
  Future<void> complete(int id);

  /// Idempotent. Removes the spawned next occurrence if it is still
  /// untouched, so an accidental completion leaves nothing behind.
  Future<void> reopen(int id);

  Future<int> addSubtask(int taskId, String title);

  Future<void> renameSubtask(int id, String title);

  Future<void> setSubtaskDone(int id, {required bool done});

  Future<void> deleteSubtask(int id);

  Future<void> snoozeReminder(int id, DateTime until);

  Stream<List<String>> watchCategories();

  Stream<List<String>> watchTags();
}
