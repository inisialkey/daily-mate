import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/utils/pending_writes.dart';
import 'package:daily_mate/features/notes/data/drift_note_repository.dart';
import 'package:daily_mate/features/notes/presentation/cubit/note_editor_cubit.dart';
import 'package:daily_mate/features/tasks/data/drift_task_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_database.dart';

/// Fails the first [failures] content writes, like a full disk would.
class FlakyNotes extends DriftNoteRepository {
  FlakyNotes(super._db, {this.failures = 1});

  int failures;

  @override
  Future<void> updateContent(
    int id, {
    required String title,
    required String body,
  }) {
    if (failures > 0) {
      failures--;
      throw Exception('disk full');
    }
    return super.updateContent(id, title: title, body: body);
  }
}

void main() {
  late AppDatabase db;
  late DriftNoteRepository notes;
  late DriftTaskRepository tasks;
  late PendingWrites pending;

  setUp(() {
    db = testDatabase();
    notes = DriftNoteRepository(db);
    tasks = DriftTaskRepository(db);
    pending = PendingWrites();
  });
  tearDown(() => db.close());

  Future<NoteEditorCubit> open(int id, {DriftNoteRepository? repo}) async {
    final cubit = NoteEditorCubit(repo ?? notes, tasks, pending, id);
    await cubit.stream.firstWhere((s) => s is NoteEditorLoaded);
    return cubit;
  }

  SaveStatus status(NoteEditorCubit cubit) =>
      (cubit.state as NoteEditorLoaded).status;

  test('typing marks unsaved, then saves after the pause', () async {
    final id = await notes.create(title: 'Idea');
    final cubit = await open(id);
    addTearDown(cubit.close);

    cubit.setBody('first draft');
    expect(status(cubit), SaveStatus.unsaved);
    await Future<void>.delayed(
      NoteEditorCubit.textDelay + const Duration(milliseconds: 200),
    );
    expect((await notes.note(id))!.body, 'first draft');
    expect(status(cubit), SaveStatus.saved);
  });

  test('rapid typing saves the final text when the editor closes', () async {
    final id = await notes.create(title: 'Idea');
    final cubit = await open(id);
    for (var i = 1; i <= 50; i++) {
      cubit.setBody('x' * i);
    }
    await cubit.close();
    expect((await notes.note(id))!.body, 'x' * 50);
  });

  test('quitting flushes pending text', () async {
    final id = await notes.create(title: 'Idea');
    final cubit = await open(id);
    addTearDown(cubit.close);
    cubit.setTitle('Renamed');
    await pending.flushAll();
    expect((await notes.note(id))!.title, 'Renamed');
  });

  test('a failed save keeps the text and Retry saves it', () async {
    final flaky = FlakyNotes(db);
    final id = await flaky.create(title: 'Idea');
    final cubit = await open(id, repo: flaky);
    addTearDown(cubit.close);

    cubit.setBody('precious');
    await cubit.flush();
    expect(status(cubit), SaveStatus.failed);
    expect((await notes.note(id))!.body, '');

    await cubit.flush();
    expect(status(cubit), SaveStatus.saved);
    expect((await notes.note(id))!.body, 'precious');
  });

  test('a new note left empty is discarded on close', () async {
    final id = await notes.create();
    final cubit = await open(id);
    await cubit.close();
    expect(await notes.note(id), isNull);
  });

  test('a note with content is kept on close', () async {
    final id = await notes.create();
    final cubit = await open(id);
    cubit.setBody('keep me');
    await cubit.close();
    expect((await notes.note(id))!.body, 'keep me');
  });

  test('creates a linked task from the selected text', () async {
    final id = await notes.create(title: 'Meeting');
    final cubit = await open(id);
    addTearDown(cubit.close);

    final taskId = await cubit.createTaskFromNote(
      selection: '\n  Send the deck to Rina \nsecond line',
    );
    final task = (await tasks.task(taskId))!;
    expect(task.title, 'Send the deck to Rina');
    expect(task.noteId, id);

    final fallback = await cubit.createTaskFromNote();
    expect((await tasks.task(fallback))!.title, 'Meeting');

    bool twoLinked(NoteEditorState s) =>
        s is NoteEditorLoaded && s.linkedTasks.length == 2;
    if (!twoLinked(cubit.state)) await cubit.stream.firstWhere(twoLinked);
    expect((cubit.state as NoteEditorLoaded).linkedTasks, hasLength(2));
  });

  test('links and unlinks an existing task', () async {
    final id = await notes.create(title: 'Plan');
    final taskId = await tasks.create(const TaskDraft(title: 'Book flights'));
    final cubit = await open(id);
    addTearDown(cubit.close);

    final found = await cubit.searchTasks('flights');
    await cubit.linkTask(found.single);
    expect((await tasks.task(taskId))!.noteId, id);

    await cubit.unlinkTask((await tasks.task(taskId))!);
    expect((await tasks.task(taskId))!.noteId, isNull);
  });
}
