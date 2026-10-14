import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// macOS `UNUserNotificationCenter` through flutter_local_notifications.
/// Triggers are absolute UTC instants (no time-zone database needed);
/// wall-clock reminders are recomputed by reconciliation after a time-zone
/// or clock change.
class LocalNotificationScheduler implements NotificationScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();

  static const _done = 'done';
  static const _snooze = 'snooze';

  MacOSFlutterLocalNotificationsPlugin? get _macos => _plugin
      .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin
      >();

  @override
  Future<void> initialize({
    required void Function(NotificationResponseEvent event) onResponse,
  }) async {
    DarwinNotificationCategory category(NotificationKind kind, String done) =>
        DarwinNotificationCategory(
          kind.name,
          actions: [
            DarwinNotificationAction.plain(_done, done),
            DarwinNotificationAction.plain(_snooze, 'Snooze 10 min'),
          ],
        );
    await _plugin.initialize(
      settings: InitializationSettings(
        macOS: DarwinInitializationSettings(
          // Permission is asked from the onboarding UI, never at launch.
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: [
            category(NotificationKind.reminder, 'Done'),
            category(NotificationKind.task, 'Complete'),
            DarwinNotificationCategory(NotificationKind.prayer.name),
          ],
        ),
      ),
      onDidReceiveNotificationResponse: (response) =>
          onResponse(_event(response)),
    );
  }

  @override
  Future<NotificationResponseEvent?> takeLaunchResponse() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    final response = details?.notificationResponse;
    return details?.didNotificationLaunchApp == true && response != null
        ? _event(response)
        : null;
  }

  @override
  Future<NotificationPermission> permission() async {
    final options = await _macos?.checkPermissions();
    if (options == null) return NotificationPermission.unknown;
    return options.isEnabled
        ? NotificationPermission.granted
        : NotificationPermission.denied;
  }

  @override
  Future<bool> requestPermission() async =>
      await _macos?.requestPermissions(alert: true, sound: true) ?? false;

  @override
  Future<void> openSystemSettings() async {
    await _macos?.openAppNotificationSettings();
  }

  @override
  Future<List<PendingNotification>> pending() async => [
    for (final request in await _plugin.pendingNotificationRequests())
      (id: request.id, payload: request.payload),
  ];

  @override
  Future<void> schedule(int id, PlannedNotification n) => _plugin.zonedSchedule(
    id: id,
    title: n.title,
    body: n.body.isEmpty ? null : n.body,
    scheduledDate: tz.TZDateTime.from(n.at.toUtc(), tz.UTC),
    notificationDetails: _details(n),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    payload: n.payload,
  );

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  @override
  Future<void> showNow(int id, PlannedNotification n) => _plugin.show(
    id: id,
    title: n.title,
    body: n.body,
    notificationDetails: _details(n),
    payload: n.payload,
  );

  NotificationDetails _details(PlannedNotification n) => NotificationDetails(
    macOS: DarwinNotificationDetails(
      categoryIdentifier: n.kind.name,
      threadIdentifier: n.kind.name,
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentSound: n.sound,
    ),
  );

  NotificationResponseEvent _event(NotificationResponse response) => (
    payload: response.payload,
    action: switch (response.actionId) {
      _done => NotificationActionType.done,
      _snooze => NotificationActionType.snooze,
      _ => NotificationActionType.open,
    },
  );
}
