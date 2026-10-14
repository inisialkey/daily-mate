import 'dart:async';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/utils/dates.dart';

/// Shared heartbeat for "now"-dependent UI. The timer runs only while
/// something listens, so a closed screen (or a finished test) leaves no
/// timer behind.
class AppClock {
  AppClock({this.interval = const Duration(seconds: 20)});

  final Duration interval;
  Timer? _timer;

  late final StreamController<DateTime> _ticks =
      StreamController<DateTime>.broadcast(
        onListen: () => _timer = Timer.periodic(
          interval,
          (_) => _ticks.add(clock.now()),
        ),
        onCancel: () {
          _timer?.cancel();
          _timer = null;
        },
      );

  DateTime now() => clock.now();

  /// Now, then every [interval].
  Stream<DateTime> watchNow() async* {
    yield now();
    yield* _ticks.stream;
  }

  /// Now, then every second — for live countdowns. The periodic timer
  /// stops when the listener cancels.
  Stream<DateTime> watchSeconds() async* {
    yield now();
    yield* Stream.periodic(const Duration(seconds: 1), (_) => now());
  }

  /// Today's date now, then again whenever the date changes.
  Stream<DateTime> watchToday() async* {
    var today = dateOnly(now());
    yield today;
    await for (final tick in _ticks.stream) {
      final date = dateOnly(tick);
      if (date != today) {
        today = date;
        yield date;
      }
    }
  }
}
