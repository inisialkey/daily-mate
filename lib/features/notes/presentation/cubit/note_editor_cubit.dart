import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/pending_writes.dart';
import 'package:daily_mate/core/utils/streams.dart';
import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_editor_cubit.freezed.dart';
part 'note_editor_state.dart';

/// One open note. Typing is saved after a short pause, when the note is
/// switched or closed, when the window deactivates, and before quitting;
/// [SaveStatus] makes that visible.
class NoteEditorCubit extends Cubit<NoteEditorState> {
  NoteEditorCubit(this._notes, this._tasks, this._pendingWrites, this.noteId)
    : super(const NoteEditorState.loading()) {
    _pendingWrites.register(flush);
    _subscription =
        combineLatest2(
          _notes.watchNote(noteId),
          combineLatest2(
            _tasks.watchTasks(
              TaskFilter(
                noteId: noteId,
                status: TaskStatus.any,
                sort: TaskSort.created,
              ),
            ),
            combineLatest2(
              _notes.watchFolders(),
              _notes.watchTags(),
              (folders, tags) => (folders: folders, tags: tags),
            ),
            (tasks, lists) => (tasks: tasks, lists: lists),
          ),
          (note, rest) => (note: note, rest: rest),
        ).listen(
          (data) {
            _note = data.note;
            final note = data.note;
            emit(
              note == null
                  ? const NoteEditorState.missing()
                  : NoteEditorState.loaded(
                      note: note,
                      status: _status,
                      linkedTasks: data.rest.tasks,
                      folders: data.rest.lists.folders,
                      tags: data.rest.lists.tags,
                    ),
            );
          },
          onError: (Object error, StackTrace stack) {
            AppLogger.e('Note editor failed', error, stack);
            emit(const NoteEditorState.error("Couldn't load this note."));
          },
        );
  }

  static const Duration textDelay = Duration(milliseconds: 600);

  final NoteRepository _notes;
  final TaskRepository _tasks;
  final PendingWrites _pendingWrites;
  final int noteId;
  late final StreamSubscription<void> _subscription;
  Note? _note;
  String? _pendingTitle;
  String? _pendingBody;
  Timer? _debounce;
  SaveStatus _status = SaveStatus.saved;

  void setTitle(String title) {
    _pendingTitle = title;
    _changed();
  }

  void setBody(String body) {
    _pendingBody = body;
    _changed();
  }

  /// Writes pending text now. A failed write keeps the text pending so the
  /// next attempt (pause, close, quit or Retry) saves it.
  Future<void> flush() async {
    _debounce?.cancel();
    final note = _note;
    final pendingTitle = _pendingTitle;
    final pendingBody = _pendingBody;
    if (note == null || (pendingTitle == null && pendingBody == null)) return;
    final title = pendingTitle ?? note.title;
    final body = pendingBody ?? note.body;
    _pendingTitle = null;
    _pendingBody = null;
    _setStatus(SaveStatus.saving);
    try {
      await _notes.updateContent(noteId, title: title, body: body);
      // Typing during the write leaves newer text pending.
      final dirty = _pendingTitle != null || _pendingBody != null;
      _setStatus(dirty ? SaveStatus.unsaved : SaveStatus.saved);
    } on Exception catch (error, stack) {
      AppLogger.e('Saving note $noteId failed', error, stack);
      _pendingTitle ??= title;
      _pendingBody ??= body;
      _setStatus(SaveStatus.failed);
    }
  }

  Future<void> setPinned({required bool pinned}) =>
      _notes.setPinned(noteId, pinned: pinned);

  Future<void> setArchived({required bool archived}) =>
      _notes.setArchived(noteId, archived: archived);

  Future<void> setFolder(String? folder) => _notes.setFolder(noteId, folder);

  Future<void> setTags(List<String> tags) => _notes.setTags(noteId, tags);

  Future<void> deleteNote() async {
    _clearPending();
    await _notes.delete(noteId);
  }

  /// A task linked to this note, titled from [selection] (first line) when
  /// text is selected, otherwise from the note's title.
  Future<int> createTaskFromNote({String? selection}) async {
    await flush();
    final picked = selection
        ?.split('\n')
        .map((line) => line.trim())
        .firstWhere((line) => line.isNotEmpty, orElse: () => '');
    final title = picked == null || picked.isEmpty
        ? (_note?.displayTitle ?? 'Follow up')
        : picked;
    return _tasks.create(
      TaskDraft(
        title: title.length > TaskDraft.maxTitleLength
            ? title.substring(0, TaskDraft.maxTitleLength)
            : title,
        noteId: noteId,
      ),
    );
  }

  /// Open tasks matching [query], for the link picker.
  Future<List<Task>> searchTasks(String query) => _tasks.tasks(
    TaskFilter(search: query, sort: TaskSort.created, limit: 30),
  );

  Future<void> linkTask(Task task) =>
      _tasks.update(task.id, TaskDraft.fromTask(task).copyWith(noteId: noteId));

  Future<void> unlinkTask(Task task) =>
      _tasks.update(task.id, TaskDraft.fromTask(task).copyWith(noteId: null));

  Future<void> toggleTask(Task task) =>
      task.isCompleted ? _tasks.reopen(task.id) : _tasks.complete(task.id);

  void _changed() {
    _setStatus(SaveStatus.unsaved);
    _debounce?.cancel();
    _debounce = Timer(textDelay, () => unawaited(flush()));
  }

  void _clearPending() {
    _debounce?.cancel();
    _pendingTitle = null;
    _pendingBody = null;
  }

  void _setStatus(SaveStatus status) {
    _status = status;
    final current = state;
    if (current is NoteEditorLoaded && !isClosed) {
      emit(current.copyWith(status: status));
    }
  }

  @override
  Future<void> close() async {
    await flush();
    _pendingWrites.unregister(flush);
    await _subscription.cancel();
    await _discardIfEmpty();
    return super.close();
  }

  /// A note left completely empty was never really written; drop it. Reads
  /// fresh rows: the stream snapshot can predate the final flush.
  Future<void> _discardIfEmpty() async {
    if (_status != SaveStatus.saved) return;
    try {
      final note = await _notes.note(noteId);
      if (note == null || !note.isBlank || note.tags.isNotEmpty) return;
      final linked = await _tasks.tasks(
        TaskFilter(noteId: noteId, status: TaskStatus.any, limit: 1),
      );
      if (linked.isEmpty) await _notes.delete(noteId);
    } on Exception catch (error, stack) {
      AppLogger.w('Discarding empty note failed', error, stack);
    }
  }
}
