import 'package:daily_mate/core/recurrence/recurrence.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime d(int y, int m, int day) => DateTime(y, m, day);

List<DateTime> series(RecurrenceRule rule, DateTime anchor, int count) {
  final out = <DateTime>[anchor];
  while (out.length < count) {
    out.add(Recurrence.nextAfter(rule, anchor: anchor, after: out.last)!);
  }
  return out;
}

void main() {
  group('daily', () {
    test('every day', () {
      expect(series(RecurrenceRule.daily, d(2026, 10, 30), 4), [
        d(2026, 10, 30),
        d(2026, 10, 31),
        d(2026, 11, 1),
        d(2026, 11, 2),
      ]);
    });

    test('every 3 days across a month end', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.daily,
        interval: 3,
      );
      expect(series(rule, d(2026, 1, 30), 3), [
        d(2026, 1, 30),
        d(2026, 2, 2),
        d(2026, 2, 5),
      ]);
    });

    test('a date before the anchor resolves to the anchor', () {
      expect(
        Recurrence.nextAfter(
          RecurrenceRule.daily,
          anchor: d(2026, 10, 20),
          after: d(2026, 10, 1),
        ),
        d(2026, 10, 20),
      );
    });

    test('time of day in `after` is ignored', () {
      expect(
        Recurrence.nextAfter(
          RecurrenceRule.daily,
          anchor: d(2026, 10, 1),
          after: DateTime(2026, 10, 14, 23, 59),
        ),
        d(2026, 10, 15),
      );
    });
  });

  group('weekly', () {
    test('defaults to the anchor weekday', () {
      // 2026-10-14 is a Wednesday.
      expect(series(RecurrenceRule.weekly, d(2026, 10, 14), 3), [
        d(2026, 10, 14),
        d(2026, 10, 21),
        d(2026, 10, 28),
      ]);
    });

    test('selected weekdays (Mon, Wed, Fri)', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        weekdays: {DateTime.monday, DateTime.wednesday, DateTime.friday},
      );
      expect(series(rule, d(2026, 10, 14), 4), [
        d(2026, 10, 14),
        d(2026, 10, 16),
        d(2026, 10, 19),
        d(2026, 10, 21),
      ]);
    });

    test('weekdays only skips the weekend', () {
      expect(
        Recurrence.nextAfter(
          RecurrenceRule.weekdaysOnly,
          anchor: d(2026, 10, 12),
          after: d(2026, 10, 16),
        ),
        d(2026, 10, 19),
      );
    });

    test('every 2 weeks skips the off week', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        interval: 2,
      );
      expect(series(rule, d(2026, 10, 12), 3), [
        d(2026, 10, 12),
        d(2026, 10, 26),
        d(2026, 11, 9),
      ]);
    });

    test('every 2 weeks on Tue+Thu stays in the on-weeks', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        interval: 2,
        weekdays: {DateTime.tuesday, DateTime.thursday},
      );
      expect(series(rule, d(2026, 10, 13), 4), [
        d(2026, 10, 13),
        d(2026, 10, 15),
        d(2026, 10, 27),
        d(2026, 10, 29),
      ]);
    });

    test('anchor not on a selected weekday starts at the next match', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        weekdays: {DateTime.monday},
      );
      expect(
        Recurrence.nextAfter(
          rule,
          anchor: d(2026, 10, 14),
          after: d(2026, 10, 13),
        ),
        d(2026, 10, 19),
      );
    });

    test('crosses the year end', () {
      expect(series(RecurrenceRule.weekly, d(2026, 12, 28), 2), [
        d(2026, 12, 28),
        d(2027, 1, 4),
      ]);
    });
  });

  group('monthly', () {
    test('the 31st clamps to short months and comes back', () {
      expect(series(RecurrenceRule.monthly, d(2026, 1, 31), 5), [
        d(2026, 1, 31),
        d(2026, 2, 28),
        d(2026, 3, 31),
        d(2026, 4, 30),
        d(2026, 5, 31),
      ]);
    });

    test('the 29th of February in a leap year', () {
      expect(series(RecurrenceRule.monthly, d(2028, 1, 29), 3), [
        d(2028, 1, 29),
        d(2028, 2, 29),
        d(2028, 3, 29),
      ]);
    });

    test('every 2 months across the year end', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.monthly,
        interval: 2,
      );
      expect(series(rule, d(2026, 11, 30), 3), [
        d(2026, 11, 30),
        d(2027, 1, 30),
        d(2027, 3, 30),
      ]);
    });

    test('from a clamped occurrence the next one keeps the anchor day', () {
      expect(
        Recurrence.nextAfter(
          RecurrenceRule.monthly,
          anchor: d(2026, 1, 31),
          after: d(2026, 2, 28),
        ),
        d(2026, 3, 31),
      );
    });
  });

  group('yearly', () {
    test('29 February falls back to the 28th in common years', () {
      expect(series(RecurrenceRule.yearly, d(2028, 2, 29), 5), [
        d(2028, 2, 29),
        d(2029, 2, 28),
        d(2030, 2, 28),
        d(2031, 2, 28),
        d(2032, 2, 29),
      ]);
    });
  });

  group('until', () {
    test('no occurrence after the end date', () {
      final rule = RecurrenceRule.daily.copyWith(until: d(2026, 10, 16));
      expect(
        Recurrence.nextAfter(
          rule,
          anchor: d(2026, 10, 14),
          after: d(2026, 10, 15),
        ),
        d(2026, 10, 16),
      );
      expect(
        Recurrence.nextAfter(
          rule,
          anchor: d(2026, 10, 14),
          after: d(2026, 10, 16),
        ),
        isNull,
      );
    });
  });

  group('completion', () {
    final today = d(2026, 10, 14);

    test('on time: the next occurrence after the due date', () {
      expect(
        Recurrence.nextDueAfterCompletion(
          RecurrenceRule.daily,
          anchor: d(2026, 10, 1),
          due: today,
          today: today,
        ),
        d(2026, 10, 15),
      );
    });

    test('early: still the occurrence after the due date', () {
      expect(
        Recurrence.nextDueAfterCompletion(
          RecurrenceRule.weekly,
          anchor: d(2026, 10, 20),
          due: d(2026, 10, 20),
          today: today,
        ),
        d(2026, 10, 27),
      );
    });

    test('late daily task comes back today, not in the past', () {
      expect(
        Recurrence.nextDueAfterCompletion(
          RecurrenceRule.daily,
          anchor: d(2026, 10, 1),
          due: d(2026, 10, 10),
          today: today,
        ),
        today,
      );
    });

    test('late weekly task skips the missed week', () {
      // Mondays; due 5 Oct, completed Wednesday 14 Oct.
      expect(
        Recurrence.nextDueAfterCompletion(
          RecurrenceRule.weekly,
          anchor: d(2026, 9, 28),
          due: d(2026, 10, 5),
          today: today,
        ),
        d(2026, 10, 19),
      );
    });
  });

  test('between lists occurrences in an inclusive range', () {
    expect(
      Recurrence.between(
        RecurrenceRule.weekdaysOnly,
        anchor: d(2026, 10, 1),
        from: d(2026, 10, 16),
        to: d(2026, 10, 20),
      ).toList(),
      [d(2026, 10, 16), d(2026, 10, 19), d(2026, 10, 20)],
    );
  });

  test('between is bounded', () {
    expect(
      Recurrence.between(
        RecurrenceRule.daily,
        anchor: d(2000, 1, 1),
        from: d(2000, 1, 1),
        to: d(2100, 1, 1),
      ).length,
      Recurrence.maxOccurrences,
    );
  });

  test('weekday mask round-trips', () {
    const days = {DateTime.monday, DateTime.friday, DateTime.sunday};
    expect(weekdaysFromMask(weekdaysToMask(days)), days);
  });
}
