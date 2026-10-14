import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/streams.dart';
import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:daily_mate/features/notes/domain/note_filter.dart';
import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_cubit.freezed.dart';
part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit(this._notes) : super(const NotesState.loading()) {
    _subscribe();
  }

  final NoteRepository _notes;
  NoteFilter _filter = const NoteFilter();
  StreamSubscription<NotesState>? _subscription;

  NoteFilter get filter => _filter;

  void setFilter(NoteFilter filter) {
    _filter = filter;
    _subscribe();
  }

  /// New empty note in the current folder; the editor discards it again if
  /// it is left empty.
  Future<int> createNote() => _notes.create(folder: _filter.folder);

  Future<void> deleteNote(int id) => _notes.delete(id);

  Future<void> setNotePinned(Note note, {required bool pinned}) =>
      _notes.setPinned(note.id, pinned: pinned);

  Future<void> setNoteArchived(Note note, {required bool archived}) =>
      _notes.setArchived(note.id, archived: archived);

  void _subscribe() {
    unawaited(_subscription?.cancel());
    final filter = _filter;
    _subscription =
        combineLatest2(
          _notes.watchNotes(filter),
          combineLatest2(
            _notes.watchFolders(),
            _notes.watchTags(),
            (folders, tags) => (folders: folders, tags: tags),
          ),
          (notes, lists) => NotesState.loaded(
            notes: notes,
            filter: filter,
            folders: lists.folders,
            tags: lists.tags,
          ),
        ).listen(
          emit,
          onError: (Object error, StackTrace stack) {
            AppLogger.e('Notes list failed', error, stack);
            emit(const NotesState.error("Couldn't load notes."));
          },
        );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
