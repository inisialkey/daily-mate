import 'package:daily_mate/features/reminders/domain/notification_models.dart';

/// A feature that wants alerts: reminders, task deadlines, prayer times.
abstract interface class NotificationSource {
  /// Whether passed alerts belong in reminder history (prayers do not).
  bool get logsHistory;

  /// Alerts whose moment lies within [from]..[to].
  Future<List<PlannedNotification>> alertsBetween(DateTime from, DateTime to);
}
