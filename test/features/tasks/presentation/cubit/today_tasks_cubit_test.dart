import 'package:clock/clock.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/features/tasks/data/drift_task_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/today_tasks_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/static_app_clock.dart';
import '../../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftTaskRepository repo;
  final now = DateTime(2026, 10, 14, 9);

  setUp(() {
    db = testDatabase();
    repo = DriftTaskRepository(db);
  });
  tearDown(() => db.close());

  test('splits overdue, today and completed-today', () {
    return withClock(Clock.fixed(now), () async {
      await repo.create(
        TaskDraft(title: 'Late', dueDate: DateTime(2026, 10, 12)),
      );
      final todayId = await repo.create(
        TaskDraft(title: 'Now', dueDate: DateTime(2026, 10, 14)),
      );
      await repo.create(
        TaskDraft(title: 'Later', dueDate: DateTime(2026, 10, 15)),
      );
      final doneId = await repo.create(
        TaskDraft(title: 'Done', dueDate: DateTime(2026, 10, 14)),
      );
      await repo.complete(doneId);

      final cubit = TodayTasksCubit(repo, StaticAppClock());
      addTearDown(cubit.close);
      final state =
          await cubit.stream.firstWhere((s) => s is TodayTasksLoaded)
              as TodayTasksLoaded;

      expect(state.overdue.map((t) => t.title), ['Late']);
      expect(state.dueToday.map((t) => t.id), [todayId]);
      expect(state.completed.map((t) => t.title), ['Done']);
    });
  });

  test('completing a task moves it to completed', () {
    return withClock(Clock.fixed(now), () async {
      final id = await repo.create(
        TaskDraft(title: 'Now', dueDate: DateTime(2026, 10, 14)),
      );
      final cubit = TodayTasksCubit(repo, StaticAppClock());
      addTearDown(cubit.close);
      await cubit.stream.firstWhere((s) => s is TodayTasksLoaded);

      await cubit.completeTask(id);
      final state =
          await cubit.stream.firstWhere(
                (s) => s is TodayTasksLoaded && s.completed.isNotEmpty,
              )
              as TodayTasksLoaded;
      expect(state.dueToday, isEmpty);
      expect(state.completed.single.id, id);
    });
  });
}
