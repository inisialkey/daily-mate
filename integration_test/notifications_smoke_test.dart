import 'package:daily_mate/features/reminders/data/local_notification_scheduler.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// On-device check of the real macOS path (not part of `flutter test`):
///   flutter test integration_test/notifications_smoke_test.dart -d macos
/// Schedules one alert 15 s ahead, confirms macOS holds it as pending, then
/// confirms it moved to delivered (Notification Center) — the only delivery
/// evidence macOS gives an app. Needs notification permission; the first run
/// asks for it.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'a scheduled alert is held, then delivered',
    (tester) async {
      void log(String message) => debugPrint('SMOKE $message');
      final scheduler = LocalNotificationScheduler();
      await scheduler.initialize(onResponse: (_) {});

      var permission = await scheduler.permission();
      log('permission before: ${permission.name}');
      if (permission != NotificationPermission.granted) {
        final granted = await scheduler.requestPermission().timeout(
          const Duration(seconds: 90),
          onTimeout: () => false,
        );
        permission = await scheduler.permission();
        log('requested: granted=$granted, permission now ${permission.name}');
      }
      if (permission != NotificationPermission.granted) {
        log('RESULT: not authorized; cannot verify delivery');
        return;
      }

      const id = 424242;
      final at = DateTime.now().add(const Duration(seconds: 15));
      final alert = PlannedNotification(
        kind: NotificationKind.prayer,
        target: 'smoke',
        at: at,
        title: 'DailyMate check',
        body: 'Scheduled ${at.toIso8601String()} — you can dismiss this.',
      );
      await scheduler.schedule(id, alert);
      final pending = await scheduler.pending();
      final held = pending.any((p) => p.id == id && p.payload == alert.payload);
      log('held as pending: $held (${pending.length} pending total)');

      await tester.runAsync(
        () => Future<void>.delayed(const Duration(seconds: 22)),
      );
      final stillPending = (await scheduler.pending()).any((p) => p.id == id);
      final delivered =
          (await FlutterLocalNotificationsPlugin().getActiveNotifications())
              .any((n) => n.id == id);
      log('after due time: pending=$stillPending delivered=$delivered');
      final verified = held && !stillPending && delivered;
      log('RESULT: ${verified ? 'DELIVERED' : 'NOT VERIFIED'}');
      expect(held, isTrue);
      expect(delivered, isTrue);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
