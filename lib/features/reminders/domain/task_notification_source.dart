import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_source.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:daily_mate/features/tasks/domain/task.dart';
import 'package:daily_mate/features/tasks/domain/task_filter.dart';
import 'package:daily_mate/features/tasks/domain/task_repository.dart';
import 'package:intl/intl.dart';

/// Deadline reminders of open tasks.
class TaskNotificationSource implements NotificationSource {
  TaskNotificationSource(this._tasks, this._settings);

  final TaskRepository _tasks;
  final SettingsRepository _settings;

  /// Reminders fire at most this long before the due date.
  static const Duration maxLead = Duration(days: 2);

  @override
  bool get logsHistory => true;

  @override
  Future<List<PlannedNotification>> alertsBetween(
    DateTime from,
    DateTime to,
  ) async {
    final defaultMinutes = (await _settings.load()).defaultReminderMinutes;
    final candidates = await _tasks.tasks(
      TaskFilter(
        dueFrom: dateOnly(from),
        dueTo: dateOnly(to.add(maxLead)),
      ),
    );
    final alerts = <PlannedNotification>[];
    for (final task in candidates) {
      if (task.reminderOffsetMinutes == null) continue;
      PlannedNotification alert(DateTime at, String body) =>
          PlannedNotification(
            kind: NotificationKind.task,
            target: '${task.id}',
            at: at,
            title: task.title,
            body: body,
          );
      final at = task.reminderAt(defaultMinutes: defaultMinutes);
      if (at != null && !at.isBefore(from) && !at.isAfter(to)) {
        alerts.add(alert(at, _dueText(task, at)));
      }
      final snooze = task.reminderSnoozedUntil;
      if (snooze != null && !snooze.isBefore(from) && !snooze.isAfter(to)) {
        alerts.add(alert(snooze, 'Snoozed · ${_dueText(task, snooze)}'));
      }
    }
    return alerts;
  }

  /// "Due today at 10:30", "Due tomorrow".
  String _dueText(Task task, DateTime now) {
    final due = task.dueDate!;
    final days = epochDay(due) - epochDay(now);
    final day = switch (days) {
      0 => 'today',
      1 => 'tomorrow',
      _ => DateFormat('EEEE d MMM').format(due),
    };
    final minutes = task.dueMinutes;
    final time = minutes == null
        ? ''
        : ' at ${DateFormat.Hm().format(atMinutes(due, minutes))}';
    return 'Due $day$time';
  }
}
