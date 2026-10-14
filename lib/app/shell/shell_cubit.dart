import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/app_clock.dart';
import 'package:daily_mate/core/utils/streams.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shell_cubit.freezed.dart';

@freezed
abstract class ShellState with _$ShellState {
  const factory ShellState({
    /// Open tasks due today or earlier (the Today badge).
    @Default(0) int todayCount,
  }) = _ShellState;
}

/// App-scoped data for the sidebar.
class ShellCubit extends Cubit<ShellState> {
  ShellCubit(TaskRepository tasks, AppClock clock) : super(const ShellState()) {
    // ponytail: counts by loading the open list; add a COUNT query if the
    // list ever gets long enough for this to show up in a profile.
    _today =
        switchMap(
          clock.watchToday(),
          (today) => tasks.watchTasks(TaskFilter(dueTo: today)),
        ).listen(
          (list) => emit(state.copyWith(todayCount: list.length)),
          onError: (Object error, StackTrace stack) =>
              AppLogger.e('Sidebar counts failed', error, stack),
        );
  }

  late final StreamSubscription<void> _today;

  @override
  Future<void> close() async {
    await _today.cancel();
    return super.close();
  }
}
