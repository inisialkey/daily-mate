import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// The single logging facade; call sites never touch a raw [Logger].
/// Debug builds log to the console, every build writes info+ to rotating
/// files once [init] receives a directory. No task or note content is
/// logged — only ids and event names.
abstract final class AppLogger {
  static Logger _logger = Logger(
    printer: SimplePrinter(colors: false),
    filter: ProductionFilter(),
  );

  static void init({String? logDirectory}) {
    _logger = Logger(
      level: kReleaseMode ? Level.info : Level.debug,
      filter: ProductionFilter(),
      printer: SimplePrinter(printTime: true, colors: false),
      output: MultiOutput([
        if (!kReleaseMode) ConsoleOutput(),
        if (logDirectory != null)
          AdvancedFileOutput(
            path: logDirectory,
            maxFileSizeKB: 512,
            maxRotatedFilesCount: 3,
            writeImmediately: [Level.warning, Level.error],
          ),
      ]),
    );
  }

  static void d(String message) => _logger.d(message);

  static void i(String message) => _logger.i(message);

  static void w(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
