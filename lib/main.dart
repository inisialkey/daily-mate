import 'package:daily_mate/app/bootstrap.dart';

Future<void> main() => bootstrap();

/// The menu bar popover's engine starts here (`AppDelegate.swift`).
@pragma('vm:entry-point')
Future<void> menuBarMain() => bootstrapMenuBar();
