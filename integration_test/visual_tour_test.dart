import 'dart:io';
import 'dart:ui' as ui;

import 'package:daily_mate/app/app.dart';
import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:daily_mate/features/reminders/domain/notification_scheduler.dart';
import 'package:daily_mate/features/settings/domain/app_theme_mode.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/test_database.dart';
import 'tour_seed.dart';

/// Renders key screens on the real macOS engine (system fonts, real
/// shaders) into PNGs for visual review, in both themes:
///   flutter test integration_test/visual_tour_test.dart -d macos
/// Output: the app container's tmp dir, `dailymate_tour/`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final out = Directory('${Directory.systemTemp.path}/dailymate_tour')
    ..createSync(recursive: true);
  final boundary = GlobalKey();

  Future<void> capture(WidgetTester tester, String name) async {
    await tester.pumpAndSettle();
    final render =
        boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await render.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    File('${out.path}/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  }

  for (final mode in [AppThemeMode.light, AppThemeMode.dark]) {
    testWidgets('tour ${mode.name}', (tester) async {
      final db = testDatabase();
      await configureDependencies(
        database: db,
        notificationScheduler: _TourScheduler(),
      );
      addTearDown(sl.reset);
      await sl<SettingsRepository>().setThemeMode(mode);
      await seedTour(db);
      final settings = await sl<SettingsRepository>().load();

      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: DailyMateApp(initialSettings: settings),
        ),
      );
      await capture(tester, '${mode.name}_today');
      await tester.tap(find.text('Review Q4 roadmap with the team'));
      await capture(tester, '${mode.name}_today_inspector');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      for (final label in tourDestinations) {
        await tester.tap(find.text(label).first);
        await capture(tester, '${mode.name}_${label.replaceAll(' ', '_')}');
        if (label == 'Reminders') {
          await tester.tap(find.text('History'));
          await capture(tester, '${mode.name}_reminders_history');
          await tester.tap(find.text('Reminders').last);
        }
        if (label == 'Notes') {
          await tester.tap(find.text('Yogyakarta trip').first);
          await capture(tester, '${mode.name}_notes_editor');
          await tester.tap(find.text('Preview'));
          await capture(tester, '${mode.name}_notes_preview');
          await tester.tap(find.text('Write'));
        }
      }
      // The tour ends on Settings: the sections below the fold.
      await tester.ensureVisible(find.text('Default reminder time'));
      await capture(tester, '${mode.name}_settings_data');
      await tester.ensureVisible(find.text('Toggle note preview'));
      await capture(tester, '${mode.name}_settings_shortcuts');

      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'trip');
      await tester.pump(const Duration(milliseconds: 300));
      await capture(tester, '${mode.name}_search');
      // Click outside to close. (Esc in a focused field goes to the macOS
      // text system, which simulated key events never reach.)
      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      // A small window: the sidebar collapses, the glance moves above.
      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await tester.pumpAndSettle();
      expect(find.text('Add a task for today'), findsOneWidget);
      tester.view.physicalSize =
          const Size(900, 700) * tester.view.devicePixelRatio;
      addTearDown(tester.view.resetPhysicalSize);
      await capture(tester, '${mode.name}_today_narrow');
    });
  }
}

/// Pretends notifications are allowed; the tour must not touch the real
/// notification center.
class _TourScheduler implements NotificationScheduler {
  @override
  Future<void> initialize({
    required void Function(NotificationResponseEvent event) onResponse,
  }) async {}

  @override
  Future<NotificationResponseEvent?> takeLaunchResponse() async => null;

  @override
  Future<NotificationPermission> permission() async =>
      NotificationPermission.unknown;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> openSystemSettings() async {}

  @override
  Future<List<PendingNotification>> pending() async => const [];

  @override
  Future<void> schedule(int id, PlannedNotification notification) async {}

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> showNow(int id, PlannedNotification notification) async {}
}
