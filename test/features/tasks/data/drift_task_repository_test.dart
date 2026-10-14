import 'dart:io';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/errors/validation_exception.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/features/tasks/data/drift_task_repository.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../../helpers/test_database.dart';

DateTime d(int y, int m, int day) => DateTime(y, m, day);

void main() {
  late AppDatabase db;
  late DriftTaskRepository repo;

  setUp(() {
    db = testDatabase();
    repo = DriftTaskRepository(db);
  });
  tearDown(() => db.close());

  /// Runs [body] with "now" fixed to [now].
  Future<T> at<T>(DateTime now, Future<T> Function() body) =>
      withClock(Clock.fixed(now), body);

  Future<List<Task>> all() =>
      repo.tasks(const TaskFilter(status: TaskStatus.any));

  group('create and update', () {
    test('persists fields and normalizes the draft', () async {
      final id = await repo.create(
        TaskDraft(
          title: '  Pay rent ',
          notes: 'Transfer before noon',
          dueDate: DateTime(2026, 10, 14, 15, 30),
          dueMinutes: 600,
          priority: Priority.high,
          category: ' Home ',
          tags: const ['bills', 'Bills', ' money  matters ', ''],
          reminderOffsetMinutes: 15,
        ),
      );
      final task = (await repo.task(id))!;
      expect(task.title, 'Pay rent');
      expect(task.dueDate, d(2026, 10, 14));
      expect(task.dueMinutes, 600);
      expect(task.priority, Priority.high);
      expect(task.category, 'Home');
      expect(task.tags, ['bills', 'money matters']);
      expect(task.reminderOffsetMinutes, 15);
    });

    test('time, repeat and reminder need a due date', () async {
      final id = await repo.create(
        const TaskDraft(
          title: 'Someday',
          dueMinutes: 60,
          recurrence: RecurrenceRule.daily,
          reminderOffsetMinutes: 0,
        ),
      );
      final task = (await repo.task(id))!;
      expect(task.dueMinutes, isNull);
      expect(task.recurrence, isNull);
      expect(task.reminderOffsetMinutes, isNull);
    });

    test('rejects an empty title', () {
      expect(
        () => repo.create(const TaskDraft(title: '   ')),
        throwsA(isA<ValidationException>()),
      );
    });

    test('an unchanged update writes nothing', () async {
      final id = await at(
        DateTime(2026, 10, 14, 9),
        () => repo.create(const TaskDraft(title: 'Read', tags: ['books'])),
      );
      final before = (await repo.task(id))!;
      await at(
        DateTime(2026, 10, 14, 10),
        () => repo.update(id, TaskDraft.fromTask(before)),
      );
      expect((await repo.task(id))!.updatedAt, before.updatedAt);
    });

    test('changing timing clears a snoozed reminder', () async {
      final id = await repo.create(
        TaskDraft(title: 'Call', dueDate: d(2026, 10, 14), dueMinutes: 600),
      );
      await repo.snoozeReminder(id, DateTime(2026, 10, 14, 10, 10));
      final task = (await repo.task(id))!;
      expect(task.reminderSnoozedUntil, isNotNull);
      await repo.update(id, TaskDraft.fromTask(task).copyWith(dueMinutes: 660));
      expect((await repo.task(id))!.reminderSnoozedUntil, isNull);
    });
  });

  group('recurrence', () {
    Future<int> daily() => repo.create(
      TaskDraft(
        title: 'Water plants',
        dueDate: d(2026, 10, 14),
        recurrence: RecurrenceRule.daily,
        tags: const ['home'],
      ),
    );

    test('completing spawns the next occurrence once', () async {
      final id = await daily();
      await repo.addSubtask(id, 'Balcony');
      final first = (await repo.task(id))!;
      await repo.setSubtaskDone(first.subtasks.single.id, done: true);

      await at(DateTime(2026, 10, 14, 18), () => repo.complete(id));
      await at(DateTime(2026, 10, 14, 18, 1), () => repo.complete(id));

      final tasks = await all();
      expect(tasks, hasLength(2));
      final next = tasks.singleWhere((t) => !t.isCompleted);
      expect(next.dueDate, d(2026, 10, 15));
      expect(next.title, 'Water plants');
      expect(next.tags, ['home']);
      expect(next.subtasks.single.done, isFalse);
      expect(next.recurrence, RecurrenceRule.daily);
    });

    test(
      'reopen removes an untouched successor; recomplete respawns one',
      () async {
        final id = await daily();
        await at(DateTime(2026, 10, 14, 18), () => repo.complete(id));
        await repo.reopen(id);
        expect(await all(), hasLength(1));
        expect((await repo.task(id))!.isCompleted, isFalse);

        await at(DateTime(2026, 10, 14, 19), () => repo.complete(id));
        expect(await all(), hasLength(2));
      },
    );

    test('reopen keeps an edited successor and never duplicates it', () async {
      final id = await daily();
      await at(DateTime(2026, 10, 14, 18), () => repo.complete(id));
      final next = (await repo.tasks(const TaskFilter())).single;
      await at(
        DateTime(2026, 10, 14, 19),
        () => repo.update(
          next.id,
          TaskDraft.fromTask(next).copyWith(title: 'Water all plants'),
        ),
      );

      await repo.reopen(id);
      await at(DateTime(2026, 10, 14, 20), () => repo.complete(id));

      final open = await repo.tasks(const TaskFilter());
      expect(open.map((t) => t.title), ['Water all plants']);
      expect(await all(), hasLength(2));
    });

    test('a late completion resumes today, skipping missed days', () async {
      final id = await repo.create(
        TaskDraft(
          title: 'Stretch',
          dueDate: d(2026, 10, 10),
          recurrence: RecurrenceRule.daily,
        ),
      );
      await at(DateTime(2026, 10, 14, 8), () => repo.complete(id));
      final next = (await repo.tasks(const TaskFilter())).single;
      expect(next.dueDate, d(2026, 10, 14));
    });

    test('monthly on the 31st keeps its anchor through short months', () async {
      var id = await repo.create(
        TaskDraft(
          title: 'Invoice',
          dueDate: d(2026, 1, 31),
          recurrence: RecurrenceRule.monthly,
        ),
      );
      final dues = <DateTime>[];
      for (final day in [d(2026, 1, 31), d(2026, 2, 28), d(2026, 3, 31)]) {
        await at(day, () => repo.complete(id));
        final next = (await repo.tasks(const TaskFilter())).single;
        dues.add(next.dueDate!);
        id = next.id;
      }
      expect(dues, [d(2026, 2, 28), d(2026, 3, 31), d(2026, 4, 30)]);
    });

    test('the series stops after its end date', () async {
      final id = await repo.create(
        TaskDraft(
          title: 'Course',
          dueDate: d(2026, 10, 14),
          recurrence: RecurrenceRule.daily.copyWith(until: d(2026, 10, 14)),
        ),
      );
      await at(DateTime(2026, 10, 14, 9), () => repo.complete(id));
      expect(await repo.tasks(const TaskFilter()), isEmpty);
    });

    test('changing the rule re-anchors; moving a date does not', () async {
      final id = await repo.create(
        TaskDraft(
          title: 'Review',
          dueDate: d(2026, 1, 31),
          recurrence: RecurrenceRule.monthly,
        ),
      );
      var task = (await repo.task(id))!;
      // Move one occurrence: still anchored on the 31st.
      await repo.update(
        id,
        TaskDraft.fromTask(task).copyWith(dueDate: d(2026, 2, 5)),
      );
      await at(d(2026, 2, 5), () => repo.complete(id));
      task = (await repo.tasks(const TaskFilter())).single;
      // Still the 31st-of-month pattern (clamped), not every 5th.
      expect(task.dueDate, d(2026, 2, 28));

      // New rule: anchored on the current due date.
      await repo.update(
        task.id,
        TaskDraft.fromTask(task).copyWith(
          dueDate: d(2026, 3, 10),
          recurrence: RecurrenceRule.weekly,
        ),
      );
      await at(d(2026, 3, 10), () => repo.complete(task.id));
      final next = (await repo.tasks(const TaskFilter())).single;
      expect(next.dueDate, d(2026, 3, 17));
    });
  });

  group('filters and sorting', () {
    setUp(() async {
      await repo.create(
        TaskDraft(title: 'Overdue', dueDate: d(2026, 10, 12)),
      );
      await repo.create(
        TaskDraft(
          title: 'Today high',
          dueDate: d(2026, 10, 14),
          priority: Priority.high,
          tags: const ['work'],
        ),
      );
      await repo.create(
        TaskDraft(
          title: 'Save 50% now',
          dueDate: d(2026, 10, 20),
          category: 'Shopping',
        ),
      );
      await repo.create(const TaskDraft(title: 'Budget 500', notes: 'x'));
    });

    test('due range', () async {
      final tasks = await repo.tasks(TaskFilter(dueTo: d(2026, 10, 14)));
      expect(tasks.map((t) => t.title), ['Overdue', 'Today high']);
    });

    test('search treats % and _ literally', () async {
      final tasks = await repo.tasks(const TaskFilter(search: '50%'));
      expect(tasks.map((t) => t.title), ['Save 50% now']);
    });

    test('tag, category and priority', () async {
      expect(
        (await repo.tasks(const TaskFilter(tag: 'WORK'))).single.title,
        'Today high',
      );
      expect(
        (await repo.tasks(const TaskFilter(category: 'Shopping'))).single.title,
        'Save 50% now',
      );
      expect(
        (await repo.tasks(
          const TaskFilter(priority: Priority.high),
        )).single.title,
        'Today high',
      );
    });

    test('due-date sort puts undated tasks last', () async {
      final titles = (await repo.tasks(const TaskFilter())).map((t) => t.title);
      expect(titles.last, 'Budget 500');
      expect(titles.first, 'Overdue');
    });

    test('completed tasks by completion time', () async {
      final open = await repo.tasks(const TaskFilter());
      await at(DateTime(2026, 10, 14, 9), () => repo.complete(open[0].id));
      await at(DateTime(2026, 10, 14, 10), () => repo.complete(open[1].id));
      final done = await repo.tasks(
        TaskFilter(
          status: TaskStatus.completed,
          sort: TaskSort.completed,
          completedFrom: DateTime(2026, 10, 14),
          completedBefore: DateTime(2026, 10, 15),
        ),
      );
      expect(done.map((t) => t.title), ['Today high', 'Overdue']);
    });
  });

  test('subtasks keep order and every change bumps the task', () async {
    final id = await at(
      DateTime(2026, 10, 14, 9),
      () => repo.create(const TaskDraft(title: 'Trip')),
    );
    await at(DateTime(2026, 10, 14, 10), () => repo.addSubtask(id, 'Tickets'));
    final second = await repo.addSubtask(id, 'Hotel');
    await repo.renameSubtask(second, 'Hotel booking');
    final task = (await repo.task(id))!;
    expect(task.subtasks.map((s) => s.title), ['Tickets', 'Hotel booking']);
    expect(task.updatedAt.isAfter(task.createdAt), isTrue);

    await repo.deleteSubtask(task.subtasks.first.id);
    expect((await repo.task(id))!.subtasks.single.title, 'Hotel booking');
  });

  test('deleting cascades to subtasks and unused tags', () async {
    final id = await repo.create(const TaskDraft(title: 'Temp', tags: ['x']));
    await repo.addSubtask(id, 'step');
    await repo.delete(id);
    expect(await db.select(db.subtasks).get(), isEmpty);
    expect(await db.select(db.tags).get(), isEmpty);
  });

  test('watchTasks re-emits when a subtask changes', () async {
    final id = await repo.create(TaskDraft(title: 'A', dueDate: d(2026, 1, 1)));
    final stream = repo.watchTasks(const TaskFilter());
    final expectation = expectLater(
      stream.map((tasks) => tasks.single.subtasks.length),
      emitsInOrder([0, 1]),
    );
    await Future<void>.delayed(Duration.zero);
    await repo.addSubtask(id, 'B');
    await expectation;
  });

  test('tasks survive closing and reopening the database file', () async {
    final dir = await Directory.systemTemp.createTemp('dailymate_db');
    addTearDown(() => dir.delete(recursive: true));
    final file = File(p.join(dir.path, 'dailymate.sqlite'));

    final first = AppDatabase(NativeDatabase(file));
    await DriftTaskRepository(first).create(
      TaskDraft(
        title: 'Persist me',
        dueDate: d(2026, 10, 14),
        recurrence: RecurrenceRule.weekdaysOnly,
      ),
    );
    await first.close();

    final second = AppDatabase(NativeDatabase(file));
    addTearDown(second.close);
    final task = (await DriftTaskRepository(second).tasks(
      const TaskFilter(),
    )).single;
    expect(task.title, 'Persist me');
    expect(task.recurrence, RecurrenceRule.weekdaysOnly);
  });
}
