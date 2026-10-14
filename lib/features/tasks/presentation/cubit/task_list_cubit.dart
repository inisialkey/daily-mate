import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/streams.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:daily_mate/features/tasks/presentation/cubit/task_commands.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_cubit.freezed.dart';
part 'task_list_state.dart';

/// A filtered, sorted, paged task list (All Tasks, Completed).
class TaskListCubit extends Cubit<TaskListState> with TaskCommands {
  TaskListCubit(this.tasks, TaskFilter initial)
    : _filter = initial.copyWith(limit: initial.limit ?? pageSize),
      super(const TaskListState.loading()) {
    _subscribe();
  }

  static const int pageSize = 200;

  @override
  final TaskRepository tasks;
  TaskFilter _filter;
  StreamSubscription<TaskListState>? _subscription;

  TaskFilter get filter => _filter;

  void setFilter(TaskFilter filter) {
    _filter = filter.copyWith(limit: pageSize);
    _subscribe();
  }

  void loadMore() {
    _filter = _filter.copyWith(limit: (_filter.limit ?? pageSize) + pageSize);
    _subscribe();
  }

  void _subscribe() {
    unawaited(_subscription?.cancel());
    final filter = _filter;
    _subscription =
        combineLatest2(
          tasks.watchTasks(filter),
          combineLatest2(
            tasks.watchCategories(),
            tasks.watchTags(),
            (categories, tags) => (categories: categories, tags: tags),
          ),
          (list, lists) => TaskListState.loaded(
            tasks: list,
            filter: filter,
            hasMore: list.length >= (filter.limit ?? pageSize),
            categories: lists.categories,
            tags: lists.tags,
          ),
        ).listen(
          emit,
          onError: (Object error, StackTrace stack) {
            AppLogger.e('Task list failed', error, stack);
            emit(const TaskListState.error("Couldn't load tasks."));
          },
        );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
