import 'package:daily_mate/core/database/app_database.dart';
import 'package:drift/drift.dart';

/// Tag bookkeeping shared by tasks and notes. Names are unique
/// case-insensitively (`COLLATE NOCASE`); unused tags are removed.
class TagStore {
  TagStore(this._db);

  final AppDatabase _db;

  /// Ids for [names], creating missing tags. Call inside a transaction.
  Future<List<int>> idsFor(List<String> names) async {
    final ids = <int>[];
    for (final name in names) {
      await _db
          .into(_db.tags)
          .insert(
            TagsCompanion.insert(name: name),
            mode: InsertMode.insertOrIgnore,
          );
      final row = await (_db.select(
        _db.tags,
      )..where((t) => t.name.equals(name))).getSingle();
      ids.add(row.id);
    }
    return ids;
  }

  Future<void> deleteUnused() => _db.customStatement(
    'DELETE FROM tags WHERE id NOT IN (SELECT tag_id FROM task_tags) '
    'AND id NOT IN (SELECT tag_id FROM note_tags)',
  );

  Stream<List<String>> watchNames() => (_db.select(
    _db.tags,
  )..orderBy([(t) => OrderingTerm.asc(t.name)])).map((row) => row.name).watch();
}

/// `LIKE` pattern matching [text] anywhere, with `\` as the escape char.
String containsPattern(String text) {
  final escaped = text
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');
  return '%$escaped%';
}
