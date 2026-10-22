import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:flutter/services.dart';

/// Bridge from the menu bar popover to `AppDelegate.swift`.
abstract final class MenuBarChannel {
  static const _channel = MethodChannel('dailymate/menu_bar');

  /// Closes the popover and shows [path] in the main window.
  static Future<void> open(String path) async {
    try {
      await _channel.invokeMethod<void>('open', path);
    } on MissingPluginException {
      // Widget tests have no native side.
    } on PlatformException catch (error, stack) {
      AppLogger.w('Menu bar channel "open" failed', error, stack);
    }
  }
}
