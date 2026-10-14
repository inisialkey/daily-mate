import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:flutter/services.dart';

/// Bridge to `MainFlutterWindow.swift`: window dragging under the transparent
/// title bar, Finder reveal, and the native "Settings…" menu item.
abstract final class WindowChannel {
  static const _channel = MethodChannel('dailymate/window');

  static Future<void> startDrag() => _invoke('startDrag');

  static Future<void> titleBarDoubleClick() => _invoke('titleBarDoubleClick');

  /// Opens a web or mail link in the default app. Other schemes (file:,
  /// custom app URLs) are ignored, so a note can't launch anything else.
  static Future<void> openUrl(String url) async {
    final scheme = Uri.tryParse(url)?.scheme.toLowerCase();
    if (const {'http', 'https', 'mailto'}.contains(scheme)) {
      await _invoke('openUrl', url);
    }
  }

  static Future<void> revealInFinder(String path) =>
      _invoke('revealInFinder', path);

  static void listen({required VoidCallback onOpenSettings}) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'openSettings') onOpenSettings();
    });
  }

  static Future<void> _invoke(String method, [Object? arguments]) async {
    try {
      await _channel.invokeMethod<void>(method, arguments);
    } on MissingPluginException {
      // Widget tests and non-macOS hosts have no native side.
    } on PlatformException catch (error, stack) {
      AppLogger.w('Window channel "$method" failed', error, stack);
    }
  }
}
