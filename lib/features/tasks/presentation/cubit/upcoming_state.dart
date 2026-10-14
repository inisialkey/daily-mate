part of 'upcoming_cubit.dart';

typedef DayTasks = ({DateTime date, List<Task> tasks});

@freezed
sealed class UpcomingState with _$UpcomingState {
  const factory UpcomingState.loading() = UpcomingLoading;
  const factory UpcomingState.loaded({
    required DateTime start,
    required DateTime today,
    required List<DayTasks> days,
  }) = UpcomingLoaded;
  const factory UpcomingState.error(String message) = UpcomingError;
}
