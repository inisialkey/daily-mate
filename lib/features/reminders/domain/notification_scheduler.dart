import 'package:daily_mate/features/reminders/domain/notification_models.dart';

/// Port to the operating system's notification scheduler.
abstract interface class NotificationScheduler {
  /// Registers categories and action buttons. [onResponse] receives taps and
  /// button presses while the app runs.
  Future<void> initialize({
    required void Function(NotificationResponseEvent event) onResponse,
  });

  /// The response that launched the app, if a notification did.
  Future<NotificationResponseEvent?> takeLaunchResponse();

  Future<NotificationPermission> permission();

  /// Asks once; afterwards macOS answers without prompting.
  Future<bool> requestPermission();

  Future<void> openSystemSettings();

  Future<List<PendingNotification>> pending();

  /// Hands the request to macOS. Success only means it was accepted, not
  /// that it will be shown — check [pending] to verify it is held.
  Future<void> schedule(int id, PlannedNotification notification);

  Future<void> cancel(int id);

  Future<void> showNow(int id, PlannedNotification notification);
}
