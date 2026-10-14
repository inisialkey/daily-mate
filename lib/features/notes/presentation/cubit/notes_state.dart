part of 'notes_cubit.dart';

@freezed
sealed class NotesState with _$NotesState {
  const factory NotesState.loading() = NotesLoading;
  const factory NotesState.loaded({
    required List<Note> notes,
    required NoteFilter filter,
    required List<String> folders,
    required List<String> tags,
  }) = NotesLoaded;
  const factory NotesState.error(String message) = NotesError;
}
