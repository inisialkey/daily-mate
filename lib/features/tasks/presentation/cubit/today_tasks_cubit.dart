import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/app_clock.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/core/utils/streams.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_commands.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_tasks_cubit.freezed.dart';
part 'today_tasks_state.dart';

/// Overdue, due-today and completed-today tasks; follows the calendar day.
class TodayTasksCubit extends Cubit<TodayTasksState> with TaskCommands {
  TodayTasksCubit(this.tasks, AppClock clock)
    : super(const TodayTasksState.loading()) {
    _subscription = switchMap(clock.watchToday(), _watchDay).listen(
      emit,
      onError: (Object error, StackTrace stack) {
        AppLogger.e('Today tasks failed', error, stack);
        emit(const TodayTasksState.error("Couldn't load today's tasks."));
      },
    );
  }

  @override
  final TaskRepository tasks;
  late final StreamSubscription<TodayTasksState> _subscription;

  Stream<TodayTasksState> _watchDay(DateTime today) => combineLatest2(
    tasks.watchTasks(TaskFilter(dueTo: today)),
    tasks.watchTasks(
      TaskFilter(
        status: TaskStatus.completed,
        completedFrom: today,
        completedBefore: addDays(today, 1),
        sort: TaskSort.completed,
      ),
    ),
    (open, done) => TodayTasksState.loaded(
      today: today,
      overdue: [
        for (final t in open)
          if (t.isOverdue(today)) t,
      ],
      dueToday: [
        for (final t in open)
          if (!t.isOverdue(today)) t,
      ],
      completed: done,
    ),
  );

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
