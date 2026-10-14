import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/app_clock.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_commands.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upcoming_cubit.freezed.dart';
part 'upcoming_state.dart';

/// A 7-day window of open tasks, starting tomorrow by default; Today has
/// its own view. Navigates by week.
class UpcomingCubit extends Cubit<UpcomingState> with TaskCommands {
  UpcomingCubit(this.tasks, AppClock clock)
    : super(const UpcomingState.loading()) {
    _days = clock.watchToday().listen((today) {
      // Follow the calendar while the user hasn't navigated away.
      final following = _today == null || _start == addDays(_today!, 1);
      _today = today;
      if (following) _show(addDays(today, 1));
    });
  }

  static const int days = 7;

  @override
  final TaskRepository tasks;
  late final StreamSubscription<DateTime> _days;
  StreamSubscription<List<Task>>? _tasks;
  DateTime? _today;
  DateTime? _start;

  void nextWeek() => _show(addDays(_start!, days));

  void previousWeek() => _show(addDays(_start!, -days));

  void thisWeek() => _show(addDays(_today!, 1));

  void _show(DateTime start) {
    _start = start;
    final end = addDays(start, days - 1);
    unawaited(_tasks?.cancel());
    _tasks = tasks
        .watchTasks(TaskFilter(dueFrom: start, dueTo: end))
        .listen(
          (list) => emit(
            UpcomingState.loaded(
              start: start,
              today: _today!,
              days: [
                for (var i = 0; i < days; i++)
                  (
                    date: addDays(start, i),
                    tasks: [
                      for (final t in list)
                        if (t.dueDate == addDays(start, i)) t,
                    ],
                  ),
              ],
            ),
          ),
          onError: (Object error, StackTrace stack) {
            AppLogger.e('Upcoming tasks failed', error, stack);
            emit(const UpcomingState.error("Couldn't load upcoming tasks."));
          },
        );
  }

  @override
  Future<void> close() async {
    await _days.cancel();
    await _tasks?.cancel();
    return super.close();
  }
}
