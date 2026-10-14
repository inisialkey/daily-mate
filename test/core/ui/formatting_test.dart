import 'package:daily_mate/core/ui/formatting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 10, 14);

  test('relative day labels', () {
    expect(formatRelativeDay(today, today), 'Today');
    expect(formatRelativeDay(DateTime(2026, 10, 15), today), 'Tomorrow');
    expect(formatRelativeDay(DateTime(2026, 10, 13), today), 'Yesterday');
    expect(formatRelativeDay(DateTime(2026, 10, 17), today), 'Saturday');
    expect(formatRelativeDay(DateTime(2026, 11, 2), today), '2 Nov');
    expect(formatRelativeDay(DateTime(2027, 1, 2), today), '2 Jan 2027');
  });

  test('greeting follows the hour', () {
    expect(greetingFor(DateTime(2026, 1, 1, 6)), 'Good morning');
    expect(greetingFor(DateTime(2026, 1, 1, 13)), 'Good afternoon');
    expect(greetingFor(DateTime(2026, 1, 1, 21)), 'Good evening');
    expect(greetingFor(DateTime(2026, 1, 1, 2)), 'Good evening');
  });

  test('durations', () {
    expect(formatShortDuration(const Duration(seconds: 30)), 'under a minute');
    expect(formatShortDuration(const Duration(minutes: 45)), '45m');
    expect(formatShortDuration(const Duration(minutes: 125)), '2h 05m');
    expect(
      formatCountdown(const Duration(hours: 1, minutes: 2, seconds: 3)),
      '01:02:03',
    );
    expect(formatCountdown(const Duration(seconds: -5)), '00:00:00');
  });
}
