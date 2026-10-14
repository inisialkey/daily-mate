import 'package:clock/clock.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/features/tasks/data/drift_task_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/upcoming_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/static_app_clock.dart';
import '../../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftTaskRepository repo;

  setUp(() {
    db = testDatabase();
    repo = DriftTaskRepository(db);
  });
  tearDown(() => db.close());

  test('shows the 7 days after today and navigates by week', () {
    return withClock(Clock.fixed(DateTime(2026, 10, 14, 9)), () async {
      await repo.create(
        TaskDraft(title: 'Today', dueDate: DateTime(2026, 10, 14)),
      );
      await repo.create(
        TaskDraft(title: 'Fri', dueDate: DateTime(2026, 10, 16)),
      );
      await repo.create(
        TaskDraft(title: 'Next', dueDate: DateTime(2026, 10, 23)),
      );

      final cubit = UpcomingCubit(repo, StaticAppClock());
      addTearDown(cubit.close);
      var state =
          await cubit.stream.firstWhere((s) => s is UpcomingLoaded)
              as UpcomingLoaded;
      expect(state.start, DateTime(2026, 10, 15));
      expect(state.days, hasLength(7));
      expect(state.days[1].tasks.single.title, 'Fri');
      expect(state.days.expand((d) => d.tasks).map((t) => t.title), ['Fri']);

      cubit.nextWeek();
      state =
          await cubit.stream.firstWhere(
                (s) => s is UpcomingLoaded && s.start == DateTime(2026, 10, 22),
              )
              as UpcomingLoaded;
      expect(state.days[1].tasks.single.title, 'Next');

      cubit.thisWeek();
      state =
          await cubit.stream.firstWhere(
                (s) => s is UpcomingLoaded && s.start == DateTime(2026, 10, 15),
              )
              as UpcomingLoaded;
      expect(state.days.first.date, DateTime(2026, 10, 15));
    });
  });
}
