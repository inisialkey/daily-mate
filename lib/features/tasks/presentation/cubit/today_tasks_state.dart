part of 'today_tasks_cubit.dart';

@freezed
sealed class TodayTasksState with _$TodayTasksState {
  const factory TodayTasksState.loading() = TodayTasksLoading;
  const factory TodayTasksState.loaded({
    required DateTime today,
    required List<Task> overdue,
    required List<Task> dueToday,
    required List<Task> completed,
  }) = TodayTasksLoaded;
  const factory TodayTasksState.error(String message) = TodayTasksError;
}
