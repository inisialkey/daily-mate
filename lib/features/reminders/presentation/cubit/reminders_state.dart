part of 'reminders_cubit.dart';

typedef UpcomingReminder = ({Reminder reminder, DateTime next});
typedef TaskAlert = ({Task task, DateTime at});

@freezed
sealed class RemindersState with _$RemindersState {
  const factory RemindersState.loading() = RemindersLoading;
  const factory RemindersState.loaded({
    required DateTime now,

    /// Enabled reminders that will still alert, soonest first.
    required List<UpcomingReminder> upcoming,

    /// One-time reminders whose moment passed without being marked done.
    required List<Reminder> past,
    required List<Reminder> off,
    required List<Reminder> done,

    /// Deadline reminders of tasks due within the next week.
    required List<TaskAlert> taskAlerts,
    required List<ReminderEvent> history,
  }) = RemindersLoaded;
  const factory RemindersState.error(String message) = RemindersError;
}
