import 'package:clock/clock.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/features/notes/data/drift_note_repository.dart';
import 'package:daily_mate/features/notes/domain/note_filter.dart';
import 'package:daily_mate/features/tasks/data/drift_task_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftNoteRepository repo;

  setUp(() {
    db = testDatabase();
    repo = DriftNoteRepository(db);
  });
  tearDown(() => db.close());

  Future<T> at<T>(DateTime now, Future<T> Function() body) =>
      withClock(Clock.fixed(now), body);

  test('content edits move updatedAt; unchanged edits do not', () async {
    final id = await at(DateTime(2026, 10), () => repo.create(title: 'A'));
    await at(
      DateTime(2026, 10, 2),
      () => repo.updateContent(id, title: 'A', body: ''),
    );
    expect((await repo.note(id))!.updatedAt, DateTime(2026, 10));
    await at(
      DateTime(2026, 10, 3),
      () => repo.updateContent(id, title: 'A', body: 'body'),
    );
    final note = (await repo.note(id))!;
    expect(note.body, 'body');
    expect(note.updatedAt, DateTime(2026, 10, 3));
  });

  test('lists pinned first, then most recently edited', () async {
    final old = await at(
      DateTime(2026, 10),
      () => repo.create(title: 'Old'),
    );
    await at(DateTime(2026, 10, 2), () => repo.create(title: 'New'));
    await at(DateTime(2026, 10, 3), () => repo.create(title: 'Newest'));
    await repo.setPinned(old, pinned: true);
    final titles = (await repo.notes(const NoteFilter())).map((n) => n.title);
    expect(titles, ['Old', 'Newest', 'New']);
  });

  test('search, folder, tag and archive filters', () async {
    final meeting = await repo.create(
      title: 'Standup',
      body: 'Discuss 100% coverage',
      folder: ' Work ',
    );
    await repo.setTags(meeting, ['team', 'Team', ' ']);
    final recipe = await repo.create(title: 'Rendang', body: 'slow cook');
    await repo.create(title: 'Old', body: 'archived thing');
    final archivedId = (await repo.notes(
      const NoteFilter(search: 'archived'),
    )).single.id;
    await repo.setArchived(archivedId, archived: true);

    expect(
      (await repo.notes(const NoteFilter(search: '100%'))).single.id,
      meeting,
    );
    expect(
      (await repo.notes(const NoteFilter(folder: 'Work'))).single.id,
      meeting,
    );
    expect((await repo.notes(const NoteFilter(tag: 'TEAM'))).single.tags, [
      'team',
    ]);
    final active = await repo.notes(const NoteFilter());
    expect(active.map((n) => n.id), unorderedEquals([meeting, recipe]));
    expect(
      (await repo.notes(const NoteFilter(archived: true))).single.id,
      archivedId,
    );
  });

  test('archiving unpins', () async {
    final id = await repo.create(title: 'Pinned');
    await repo.setPinned(id, pinned: true);
    await repo.setArchived(id, archived: true);
    final note = (await repo.note(id))!;
    expect(note.archived, isTrue);
    expect(note.pinned, isFalse);
  });

  test('deleting a note keeps linked tasks, without the link', () async {
    final tasks = DriftTaskRepository(db);
    final id = await repo.create(title: 'Spec');
    await repo.setTags(id, ['draft']);
    final taskId = await tasks.create(TaskDraft(title: 'Review', noteId: id));

    await repo.delete(id);
    expect(await repo.note(id), isNull);
    expect((await tasks.task(taskId))!.noteId, isNull);
    expect(await db.select(db.tags).get(), isEmpty);
  });

  test('folders are distinct and sorted', () async {
    await repo.create(folder: 'Work');
    await repo.create(folder: 'Home');
    await repo.create(folder: 'Work');
    await repo.create();
    expect(await repo.watchFolders().first, ['Home', 'Work']);
  });
}
