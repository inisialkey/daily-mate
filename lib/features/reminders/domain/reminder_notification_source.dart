import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_source.dart';
import 'package:daily_mate/features/reminders/domain/reminder_repository.dart';

class ReminderNotificationSource implements NotificationSource {
  ReminderNotificationSource(this._reminders);

  final ReminderRepository _reminders;

  @override
  bool get logsHistory => true;

  @override
  Future<List<PlannedNotification>> alertsBetween(
    DateTime from,
    DateTime to,
  ) async {
    final alerts = <PlannedNotification>[];
    for (final r in await _reminders.reminders()) {
      if (!r.enabled || r.completedAt != null) continue;
      final body = r.notes.trim().split('\n').first;
      PlannedNotification alert(DateTime at, {String? note}) =>
          PlannedNotification(
            kind: NotificationKind.reminder,
            target: '${r.id}',
            at: at,
            title: r.title,
            body: note ?? body,
          );
      alerts.addAll(r.occurrencesBetween(from, to).map(alert));
      final snooze = r.snoozedUntil;
      if (snooze != null && !snooze.isBefore(from) && !snooze.isAfter(to)) {
        alerts.add(alert(snooze, note: 'Snoozed reminder'));
      }
    }
    return alerts;
  }
}
