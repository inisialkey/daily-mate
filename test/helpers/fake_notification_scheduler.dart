import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_scheduler.dart';

/// In-memory stand-in for macOS's pending-notification store.
class FakeNotificationScheduler implements NotificationScheduler {
  NotificationPermission permissionValue = NotificationPermission.granted;
  bool grantOnRequest = true;

  /// id -> payload, like `getPendingNotificationRequests`.
  final Map<int, String?> held = {};
  final Map<int, PlannedNotification> notifications = {};
  final List<int> scheduleCalls = [];
  final List<int> cancelCalls = [];
  final List<PlannedNotification> shown = [];
  void Function(NotificationResponseEvent event)? onResponse;
  NotificationResponseEvent? launchResponse;
  int settingsOpened = 0;

  void clearCalls() {
    scheduleCalls.clear();
    cancelCalls.clear();
  }

  List<PlannedNotification> get heldNotifications =>
      (notifications.values.toList()..sort((a, b) => a.at.compareTo(b.at)));

  @override
  Future<void> initialize({
    required void Function(NotificationResponseEvent event) onResponse,
  }) async => this.onResponse = onResponse;

  @override
  Future<NotificationResponseEvent?> takeLaunchResponse() async {
    final response = launchResponse;
    launchResponse = null;
    return response;
  }

  @override
  Future<NotificationPermission> permission() async => permissionValue;

  @override
  Future<bool> requestPermission() async {
    if (grantOnRequest) permissionValue = NotificationPermission.granted;
    return grantOnRequest;
  }

  @override
  Future<void> openSystemSettings() async => settingsOpened++;

  @override
  Future<List<PendingNotification>> pending() async => [
    for (final entry in held.entries) (id: entry.key, payload: entry.value),
  ];

  @override
  Future<void> schedule(int id, PlannedNotification notification) async {
    scheduleCalls.add(id);
    held[id] = notification.payload;
    notifications[id] = notification;
  }

  @override
  Future<void> cancel(int id) async {
    cancelCalls.add(id);
    held.remove(id);
    notifications.remove(id);
  }

  @override
  Future<void> showNow(int id, PlannedNotification notification) async =>
      shown.add(notification);
}
