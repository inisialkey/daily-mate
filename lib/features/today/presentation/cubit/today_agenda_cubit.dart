import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/app_clock.dart';
import 'package:daily_mate/core/utils/streams.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/reminder_notification_source.dart';
import 'package:daily_mate/features/reminders/domain/reminder_repository.dart';
import 'package:daily_mate/features/reminders/domain/task_notification_source.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_agenda_cubit.freezed.dart';

@freezed
sealed class TodayAgendaState with _$TodayAgendaState {
  const factory TodayAgendaState.loading() = TodayAgendaLoading;
  const factory TodayAgendaState.loaded({
    required DateTime now,

    /// Reminder and task alerts in the next [TodayAgendaCubit.window],
    /// soonest first — the same alerts macOS is asked to deliver.
    required List<PlannedNotification> alerts,
  }) = TodayAgendaLoaded;
}

class TodayAgendaCubit extends Cubit<TodayAgendaState> {
  TodayAgendaCubit(
    ReminderNotificationSource reminderAlerts,
    TaskNotificationSource taskAlerts,
    ReminderRepository reminders,
    TaskRepository tasks,
    AppClock clock,
  ) : super(const TodayAgendaState.loading()) {
    _subscription =
        combineLatest2(
              combineLatest2(
                reminders.watchReminders(),
                tasks.watchTasks(const TaskFilter(limit: 1)),
                (_, _) => null,
              ),
              clock.watchNow(),
              (_, now) => now,
            )
            .asyncMap((now) async {
              final to = now.add(window);
              final alerts = [
                ...await reminderAlerts.alertsBetween(now, to),
                ...await taskAlerts.alertsBetween(now, to),
              ]..sort((a, b) => a.at.compareTo(b.at));
              return TodayAgendaState.loaded(
                now: now,
                alerts: alerts.where((a) => a.at.isAfter(now)).take(6).toList(),
              );
            })
            .listen(
              emit,
              onError: (Object error, StackTrace stack) =>
                  AppLogger.e('Today agenda failed', error, stack),
            );
  }

  static const Duration window = Duration(hours: 24);

  late final StreamSubscription<TodayAgendaState> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
