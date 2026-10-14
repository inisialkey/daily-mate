part of 'task_editor_cubit.dart';

@freezed
sealed class TaskEditorState with _$TaskEditorState {
  const factory TaskEditorState.loading() = TaskEditorLoading;
  const factory TaskEditorState.loaded({
    required Task task,
    required List<String> categories,
    required List<String> tags,

    /// Notes the task can be linked to (not archived).
    required List<Note> notes,
  }) = TaskEditorLoaded;

  /// The task was deleted (here or elsewhere).
  const factory TaskEditorState.missing() = TaskEditorMissing;
  const factory TaskEditorState.error(String message) = TaskEditorError;
}
