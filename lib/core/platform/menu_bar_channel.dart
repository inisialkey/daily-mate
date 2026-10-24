import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:flutter/services.dart';

/// Bridge from the menu bar popover to `AppDelegate.swift`.
abstract final class MenuBarChannel {
  static const _channel = MethodChannel('dailymate/menu_bar');

  /// Closes the popover and shows [path] in the main window.
  static Future<void> open(String path) => _invoke<void>('open', path);

  /// Whether an app with [bundleId] is running.
  static Future<bool> isRunning(String bundleId) async =>
      await _invoke<bool>('isRunning', bundleId) ?? false;

  /// Presses the media key `previous`, `playPause` or `next`. The first
  /// press asks for the Accessibility permission instead.
  static Future<void> pressMediaKey(String key) =>
      _invoke<void>('pressMediaKey', key);

  static Future<T?> _invoke<T>(String method, Object? arguments) async {
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      // Widget tests have no native side.
    } on PlatformException catch (error, stack) {
      AppLogger.w('Menu bar channel "$method" failed', error, stack);
    }
    return null;
  }
}
