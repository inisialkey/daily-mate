import 'dart:io';
import 'dart:ui';

import 'package:daily_mate/app/app.dart';
import 'package:daily_mate/app/startup_error_app.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/streams.dart';
import 'package:daily_mate/features/menu_bar/presentation/menu_bar_app.dart';
import 'package:daily_mate/features/reminders/domain/notification_sync.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Initializes logging, error hooks, DI and the database (once), then runs
/// the app. A database that cannot open shows a recovery screen instead of
/// crashing, so the data file is never touched by a half-started app.
Future<void> bootstrap() async {
  final supportDirectory = await _startLogging('logs');
  await configureDependencies();
  try {
    final settings = await sl<SettingsRepository>().load();
    await _startNotifications();
    AppLogger.i('DailyMate started');
    runApp(DailyMateApp(initialSettings: settings));
  } on Exception catch (error, stack) {
    AppLogger.e('Database failed to open', error, stack);
    runApp(
      StartupErrorApp(error: error, dataDirectory: supportDirectory.path),
    );
  }
}

/// The menu bar popover: the same dependencies and database, in its own
/// engine. Notifications stay with the main app, which sees the popover's
/// writes through the shared database. Logs go to their own folder, since
/// two writers would fight over the rotating files.
Future<void> bootstrapMenuBar() async {
  await _startLogging(p.join('logs', 'menu_bar'));
  await configureDependencies();
  AppLogger.i('Menu bar started');
  runApp(const MenuBarApp());
}

/// Logging and error hooks; returns the Application Support directory.
Future<Directory> _startLogging(String folder) async {
  WidgetsFlutterBinding.ensureInitialized();
  final supportDirectory = await getApplicationSupportDirectory();
  final logDirectory = Directory(p.join(supportDirectory.path, folder))
    ..createSync(recursive: true);
  AppLogger.init(logDirectory: logDirectory.path);

  FlutterError.onError = (details) {
    AppLogger.e('Flutter error', details.exception, details.stack);
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.e('Uncaught error', error, stack);
    return true;
  };
  return supportDirectory;
}

/// Registers with macOS (handling a launch from a notification), then keeps
/// scheduled alerts in step with the data. A failure here must never stop
/// the app from opening; reconciliation retries on every change anyway.
Future<void> _startNotifications() async {
  final sync = sl<NotificationSync>();
  try {
    await sync.attach();
  } on Exception catch (error, stack) {
    AppLogger.e('Notification setup failed', error, stack);
  }
  final db = sl<AppDatabase>();
  final settings = sl<SettingsRepository>();
  sync.start(
    changes: mergeStreams<void>([
      db.watchTables({
        db.reminders,
        db.tasks,
        db.prayerSettingsTable,
        db.prayerPreferences,
      }),
      settings.watch().map((s) => s.defaultReminderMinutes).distinct(),
    ]),
  );
}
