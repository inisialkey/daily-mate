import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/utils/pending_writes.dart';
import 'package:daily_mate/features/notes/data/drift_note_repository.dart';
import 'package:daily_mate/features/tasks/data/drift_task_repository.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_editor_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftTaskRepository repo;
  late PendingWrites pending;
  late int id;

  setUp(() async {
    db = testDatabase();
    repo = DriftTaskRepository(db);
    pending = PendingWrites();
    id = await repo.create(const TaskDraft(title: 'Draft', notes: 'old'));
  });
  tearDown(() => db.close());

  Future<TaskEditorCubit> open() async {
    final cubit = TaskEditorCubit(repo, DriftNoteRepository(db), pending, id);
    await cubit.stream.firstWhere((s) => s is TaskEditorLoaded);
    return cubit;
  }

  test('typed text is saved when the editor closes', () async {
    final cubit = await open();
    cubit
      ..setTitle('Final title')
      ..setNotes('new notes');
    await cubit.close();
    final task = (await repo.task(id))!;
    expect(task.title, 'Final title');
    expect(task.notes, 'new notes');
  });

  test('typed text is saved after the pause', () async {
    final cubit = await open();
    addTearDown(cubit.close);
    cubit.setTitle('Paused');
    await Future<void>.delayed(
      TaskEditorCubit.textDelay + const Duration(milliseconds: 150),
    );
    expect((await repo.task(id))!.title, 'Paused');
  });

  test('quitting flushes through PendingWrites', () async {
    final cubit = await open();
    addTearDown(cubit.close);
    cubit.setNotes('saved on quit');
    await pending.flushAll();
    expect((await repo.task(id))!.notes, 'saved on quit');
  });

  test('other edits keep unsaved text', () async {
    final cubit = await open();
    addTearDown(cubit.close);
    cubit.setTitle('Typed but not saved yet');
    await cubit.edit((d) => d.copyWith(priority: Priority.high));
    final task = (await repo.task(id))!;
    expect(task.title, 'Typed but not saved yet');
    expect(task.priority, Priority.high);
  });

  test('an emptied title is never saved', () async {
    final cubit = await open();
    cubit.setTitle('   ');
    await cubit.close();
    expect((await repo.task(id))!.title, 'Draft');
  });

  test('reports a deleted task as missing', () async {
    final cubit = await open();
    addTearDown(cubit.close);
    await repo.delete(id);
    await expectLater(
      cubit.stream,
      emitsThrough(const TaskEditorState.missing()),
    );
  });
}
