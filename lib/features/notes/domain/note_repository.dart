import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:daily_mate/features/notes/domain/note_filter.dart';

abstract interface class NoteRepository {
  /// Pinned first, then most recently edited.
  Stream<List<Note>> watchNotes(NoteFilter filter);

  Future<List<Note>> notes(NoteFilter filter);

  /// Emits null once the note is deleted.
  Stream<Note?> watchNote(int id);

  Future<Note?> note(int id);

  Future<int> create({String title = '', String body = '', String? folder});

  /// No-op when nothing changed, so `updatedAt` only moves on real edits.
  Future<void> updateContent(
    int id, {
    required String title,
    required String body,
  });

  Future<void> setPinned(int id, {required bool pinned});

  Future<void> setArchived(int id, {required bool archived});

  Future<void> setFolder(int id, String? folder);

  Future<void> setTags(int id, List<String> tags);

  Future<void> delete(int id);

  Stream<List<String>> watchFolders();

  Stream<List<String>> watchTags();
}
