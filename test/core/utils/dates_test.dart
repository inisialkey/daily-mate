import 'package:daily_mate/core/utils/dates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('addDays crosses month and year ends', () {
    expect(addDays(DateTime(2026, 1, 31), 1), DateTime(2026, 2));
    expect(addDays(DateTime(2026, 12, 31), 1), DateTime(2027));
    expect(addDays(DateTime(2026, 3), -1), DateTime(2026, 2, 28));
  });

  test('epoch day round-trips and counts calendar days', () {
    final date = DateTime(2028, 2, 29);
    expect(fromEpochDay(epochDay(date)), date);
    expect(
      epochDay(DateTime(2026, 10, 15)) - epochDay(DateTime(2026, 10, 14)),
      1,
    );
  });

  test('daysInMonth handles leap years', () {
    expect(daysInMonth(2028, 2), 29);
    expect(daysInMonth(2026, 2), 28);
    expect(daysInMonth(2026, 4), 30);
  });

  test('startOfWeek is Monday', () {
    expect(startOfWeek(DateTime(2026, 10, 14)), DateTime(2026, 10, 12));
    expect(startOfWeek(DateTime(2026, 10, 12)), DateTime(2026, 10, 12));
    expect(startOfWeek(DateTime(2026, 10, 18)), DateTime(2026, 10, 12));
  });
}
