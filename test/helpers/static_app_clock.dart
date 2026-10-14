import 'package:daily_mate/core/utils/app_clock.dart';
import 'package:daily_mate/core/utils/dates.dart';

/// Emits "now" once and never ticks, so widget tests end without timers.
/// Pair with `withClock` to pin the date.
class StaticAppClock extends AppClock {
  @override
  Stream<DateTime> watchNow() => Stream.value(now());

  @override
  Stream<DateTime> watchSeconds() => Stream.value(now());

  @override
  Stream<DateTime> watchToday() => Stream.value(dateOnly(now()));
}
