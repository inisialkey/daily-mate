import 'package:daily_mate/app/app.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_location_service.dart';
import 'fake_notification_scheduler.dart';
import 'static_app_clock.dart';
import 'test_database.dart';

/// Desktop-sized window with the whole app wired to an in-memory database.
Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  Size size = const Size(1400, 900),
  FakeNotificationScheduler? scheduler,
  FakeLocationService? location,

  /// Runs against the database before the app is built — the only moment
  /// no query is in flight, so it can never wait on Drift's lock.
  Future<void> Function()? seed,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final db = testDatabase();
  await configureDependencies(
    database: db,
    appClock: StaticAppClock(),
    notificationScheduler: scheduler ?? FakeNotificationScheduler(),
    locationService: location ?? FakeLocationService(),
  );
  addTearDown(sl.reset);
  final settings = await tester.runAsync(() async {
    await seed?.call();
    return sl<SettingsRepository>().load();
  });
  await tester.pumpWidget(DailyMateApp(initialSettings: settings!));
  await tester.pumpAndSettle();
  // Let queries started in the fake-async zone finish: a test that then
  // touches the database via `runAsync` would otherwise wait on Drift's
  // lock forever.
  await settleAsync(tester);
  addTearDown(() => unmountApp(tester));
  return db;
}

/// Disposes the app and lets cubits finish their async `close()` (final
/// saves, empty-note cleanup) in real time before the database closes —
/// fake-async teardown would otherwise wait on them forever.
Future<void> unmountApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await settleAsync(tester);
}

/// Alternates real-time waits with pumps so work started from fake-async
/// code (database writes in `close()`, stream re-queries) can complete.
Future<void> settleAsync(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
  }
}
