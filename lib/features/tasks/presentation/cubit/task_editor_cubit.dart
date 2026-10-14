import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/pending_writes.dart';
import 'package:daily_mate/core/utils/streams.dart';
import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:daily_mate/features/notes/domain/note_filter.dart';
import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_commands.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_editor_cubit.freezed.dart';
part 'task_editor_state.dart';

/// Inspector for one task. Text fields save after a short pause (and on
/// close / quit); every other field saves immediately.
class TaskEditorCubit extends Cubit<TaskEditorState> with TaskCommands {
  TaskEditorCubit(this.tasks, this._notes, this._pendingWrites, this.taskId)
    : super(const TaskEditorState.loading()) {
    _pendingWrites.register(flush);
    _subscription =
        combineLatest2(
          tasks.watchTask(taskId),
          combineLatest2(
            combineLatest2(
              tasks.watchCategories(),
              tasks.watchTags(),
              (categories, tags) => (categories: categories, tags: tags),
            ),
            _notes.watchNotes(const NoteFilter()),
            (lists, notes) => (
              categories: lists.categories,
              tags: lists.tags,
              notes: notes,
            ),
          ),
          (task, lists) => (task: task, lists: lists),
        ).listen(
          (data) {
            final task = data.task;
            _task = task;
            emit(
              task == null
                  ? const TaskEditorState.missing()
                  : TaskEditorState.loaded(
                      task: task,
                      categories: data.lists.categories,
                      tags: data.lists.tags,
                      notes: data.lists.notes,
                    ),
            );
          },
          onError: (Object error, StackTrace stack) {
            AppLogger.e('Task editor failed', error, stack);
            emit(const TaskEditorState.error("Couldn't load this task."));
          },
        );
  }

  static const Duration textDelay = Duration(milliseconds: 400);

  @override
  final TaskRepository tasks;
  final NoteRepository _notes;
  final PendingWrites _pendingWrites;
  final int taskId;
  late final StreamSubscription<void> _subscription;
  Task? _task;
  String? _pendingTitle;
  String? _pendingNotes;
  Timer? _debounce;

  /// Applies [change] to the current values (including unsaved text) and
  /// saves at once.
  Future<void> edit(TaskDraft Function(TaskDraft draft) change) async {
    final task = _task;
    if (task == null) return;
    final draft = change(_draft(task));
    _clearPending();
    await tasks.update(taskId, draft);
  }

  void setTitle(String title) {
    _pendingTitle = title;
    _schedule();
  }

  void setNotes(String notes) {
    _pendingNotes = notes;
    _schedule();
  }

  /// Writes pending text now. An empty title is never saved: the previous
  /// one stays until a non-empty title is typed.
  Future<void> flush() async {
    _debounce?.cancel();
    final task = _task;
    if (task == null || (_pendingTitle == null && _pendingNotes == null)) {
      return;
    }
    final draft = _draft(task);
    _clearPending();
    if (draft.title.trim().isEmpty) return;
    try {
      await tasks.update(taskId, draft);
    } on Exception catch (error, stack) {
      AppLogger.e('Saving task text failed', error, stack);
    }
  }

  Future<void> toggleComplete() async {
    await flush();
    final task = _task;
    if (task == null) return;
    if (task.isCompleted) {
      await reopenTask(taskId);
    } else {
      await completeTask(taskId);
    }
  }

  Future<void> addSubtask(String title) => tasks.addSubtask(taskId, title);

  Future<void> renameSubtask(int id, String title) =>
      tasks.renameSubtask(id, title);

  Future<void> toggleSubtask(Subtask subtask) =>
      tasks.setSubtaskDone(subtask.id, done: !subtask.done);

  Future<void> deleteSubtask(int id) => tasks.deleteSubtask(id);

  TaskDraft _draft(Task task) =>
      TaskDraft.fromTask(
        task,
      ).copyWith(
        title: _pendingTitle ?? task.title,
        notes: _pendingNotes ?? task.notes,
      );

  void _schedule() {
    _debounce?.cancel();
    _debounce = Timer(textDelay, () => unawaited(flush()));
  }

  void _clearPending() {
    _debounce?.cancel();
    _pendingTitle = null;
    _pendingNotes = null;
  }

  @override
  Future<void> close() async {
    await flush();
    _pendingWrites.unregister(flush);
    await _subscription.cancel();
    return super.close();
  }
}
