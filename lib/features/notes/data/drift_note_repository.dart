import 'package:clock/clock.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/database/tag_store.dart';
import 'package:daily_mate/core/utils/tags.dart';
import 'package:daily_mate/features/notes/domain/note.dart';
import 'package:daily_mate/features/notes/domain/note_filter.dart';
import 'package:daily_mate/features/notes/domain/note_repository.dart';
import 'package:drift/drift.dart';

class DriftNoteRepository implements NoteRepository {
  DriftNoteRepository(this._db) : _tags = TagStore(_db);

  final AppDatabase _db;
  final TagStore _tags;

  $NotesTable get _n => _db.notes;

  Set<ResultSetImplementation<dynamic, dynamic>> get _watched => {
    _db.notes,
    _db.noteTags,
    _db.tags,
  };

  @override
  Stream<List<Note>> watchNotes(NoteFilter filter) =>
      _db.watchTables(_watched).asyncMap((_) => notes(filter));

  // ponytail: LIKE scan over title/body; fine for thousands of notes. Move
  // to an FTS5 table if search ever feels slow.
  @override
  Future<List<Note>> notes(NoteFilter filter) async {
    final search = filter.search.trim();
    final query = _db.select(_n)
      ..where((n) {
        final conditions = <Expression<bool>>[
          n.isArchived.equals(filter.archived),
          if (filter.folder case final folder?) n.folder.equals(folder),
          if (filter.tag case final tag?) n.id.isInQuery(_taggedWith(tag)),
          if (search.isNotEmpty)
            n.title.like(containsPattern(search), escapeChar: r'\') |
                n.body.like(containsPattern(search), escapeChar: r'\'),
        ];
        return conditions.reduce((a, b) => a & b);
      })
      ..orderBy([
        (n) => OrderingTerm.desc(n.isPinned),
        (n) => OrderingTerm.desc(n.updatedAt),
        (n) => OrderingTerm.desc(n.id),
      ])
      ..limit(filter.limit);
    return _hydrate(await query.get());
  }

  @override
  Stream<Note?> watchNote(int id) =>
      _db.watchTables(_watched).asyncMap((_) => note(id));

  @override
  Future<Note?> note(int id) async {
    final row = await (_db.select(
      _n,
    )..where((n) => n.id.equals(id))).getSingleOrNull();
    return row == null ? null : (await _hydrate([row])).single;
  }

  @override
  Future<int> create({String title = '', String body = '', String? folder}) {
    final now = clock.now();
    return _db
        .into(_n)
        .insert(
          NotesCompanion.insert(
            title: Value(title),
            body: Value(body),
            folder: Value(_folderName(folder)),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<void> updateContent(
    int id, {
    required String title,
    required String body,
  }) =>
      _byId(
        id,
        onlyIf: (n) => n.title.equals(title).not() | n.body.equals(body).not(),
      ).write(
        NotesCompanion(
          title: Value(title),
          body: Value(body),
          updatedAt: Value(clock.now()),
        ),
      );

  @override
  Future<void> setPinned(int id, {required bool pinned}) =>
      _byId(id).write(NotesCompanion(isPinned: Value(pinned)));

  @override
  Future<void> setArchived(int id, {required bool archived}) =>
      _byId(
        id,
      ).write(
        NotesCompanion(
          isArchived: Value(archived),
          isPinned: const Value(false),
        ),
      );

  @override
  Future<void> setFolder(int id, String? folder) =>
      _byId(id).write(NotesCompanion(folder: Value(_folderName(folder))));

  @override
  Future<void> setTags(int id, List<String> tags) => _db.transaction(() async {
    final ids = await _tags.idsFor(normalizeTags(tags));
    await (_db.delete(_db.noteTags)..where((t) => t.noteId.equals(id))).go();
    await _db.batch(
      (b) => b.insertAll(_db.noteTags, [
        for (final tagId in ids)
          NoteTagsCompanion.insert(noteId: id, tagId: tagId),
      ]),
    );
    await _tags.deleteUnused();
  });

  @override
  Future<void> delete(int id) => _db.transaction(() async {
    await (_db.delete(_n)..where((n) => n.id.equals(id))).go();
    await _tags.deleteUnused();
  });

  @override
  Stream<List<String>> watchFolders() {
    final folder = _n.folder;
    return (_db.selectOnly(_n, distinct: true)
          ..addColumns([folder])
          ..where(folder.isNotNull())
          ..orderBy([OrderingTerm.asc(folder)]))
        .map((row) => row.read(folder)!)
        .watch();
  }

  @override
  Stream<List<String>> watchTags() => _tags.watchNames();

  UpdateStatement<$NotesTable, NoteRow> _byId(
    int id, {
    Expression<bool> Function($NotesTable n)? onlyIf,
  }) => _db.update(_n)
    ..where((n) {
      final match = n.id.equals(id);
      return onlyIf == null ? match : match & onlyIf(n);
    });

  String? _folderName(String? folder) {
    final name = folder?.trim();
    return name == null || name.isEmpty ? null : name;
  }

  BaseSelectStatement<TypedResult> _taggedWith(String tag) =>
      _db.selectOnly(_db.noteTags).join([
          innerJoin(
            _db.tags,
            _db.tags.id.equalsExp(_db.noteTags.tagId),
            useColumns: false,
          ),
        ])
        ..addColumns([_db.noteTags.noteId])
        ..where(_db.tags.name.equals(tag));

  Future<List<Note>> _hydrate(List<NoteRow> rows) async {
    if (rows.isEmpty) return const [];
    final ids = [for (final row in rows) row.id];
    final tagRows =
        await (_db.select(_db.noteTags).join([
                innerJoin(_db.tags, _db.tags.id.equalsExp(_db.noteTags.tagId)),
              ])
              ..where(_db.noteTags.noteId.isIn(ids))
              ..orderBy([OrderingTerm.asc(_db.tags.name)]))
            .get();
    final tagsByNote = <int, List<String>>{};
    for (final r in tagRows) {
      tagsByNote
          .putIfAbsent(r.readTable(_db.noteTags).noteId, () => [])
          .add(r.readTable(_db.tags).name);
    }
    return [
      for (final row in rows)
        Note(
          id: row.id,
          title: row.title,
          body: row.body,
          folder: row.folder,
          tags: tagsByNote[row.id] ?? const [],
          pinned: row.isPinned,
          archived: row.isArchived,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
        ),
    ];
  }
}
