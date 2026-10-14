part of 'task_list_cubit.dart';

@freezed
sealed class TaskListState with _$TaskListState {
  const factory TaskListState.loading() = TaskListLoading;
  const factory TaskListState.loaded({
    required List<Task> tasks,
    required TaskFilter filter,
    required bool hasMore,
    required List<String> categories,
    required List<String> tags,
  }) = TaskListLoaded;
  const factory TaskListState.error(String message) = TaskListError;
}
