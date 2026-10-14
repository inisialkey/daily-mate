part of 'note_editor_cubit.dart';

enum SaveStatus { saved, unsaved, saving, failed }

@freezed
sealed class NoteEditorState with _$NoteEditorState {
  const factory NoteEditorState.loading() = NoteEditorLoading;
  const factory NoteEditorState.loaded({
    required Note note,
    required SaveStatus status,
    required List<Task> linkedTasks,
    required List<String> folders,
    required List<String> tags,
  }) = NoteEditorLoaded;

  /// Deleted here or elsewhere.
  const factory NoteEditorState.missing() = NoteEditorMissing;
  const factory NoteEditorState.error(String message) = NoteEditorError;
}
