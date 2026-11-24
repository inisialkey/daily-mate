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

  /// Presses the media key `previous`, `playPause` or `next`; false when
  /// macOS refuses because the Accessibility permission is missing.
  static Future<bool> pressMediaKey(String key) async =>
      await _invoke<bool>('pressMediaKey', key) ?? true;

  /// Closes the popover and opens Privacy & Security > Accessibility.
  static Future<void> openAccessibilitySettings() =>
      _invoke<void>('openAccessibilitySettings', null);

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
