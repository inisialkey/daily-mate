import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/features/reminders/domain/reminder.dart';
import 'package:flutter_test/flutter_test.dart';

Reminder reminder({
  required DateTime date,
  int minutes = 9 * 60,
  RecurrenceRule? recurrence,
  bool enabled = true,
  DateTime? snoozedUntil,
  DateTime? completedAt,
}) => Reminder(
  id: 1,
  title: 'Stretch',
  date: date,
  minutes: minutes,
  recurrence: recurrence,
  enabled: enabled,
  snoozedUntil: snoozedUntil,
  completedAt: completedAt,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  final day = DateTime(2026, 10, 14);

  group('one-time', () {
    final r = reminder(date: day);

    test('next occurrence is its moment until it passes', () {
      expect(
        r.nextOccurrence(DateTime(2026, 10, 14, 8)),
        DateTime(2026, 10, 14, 9),
      );
      expect(r.nextOccurrence(DateTime(2026, 10, 14, 9)), isNull);
    });

    test('past and upcoming', () {
      expect(r.isUpcoming(DateTime(2026, 10, 14, 8)), isTrue);
      expect(r.isPast(DateTime(2026, 10, 14, 9, 1)), isTrue);
      expect(r.isUpcoming(DateTime(2026, 10, 14, 9, 1)), isFalse);
    });

    test('a pending snooze keeps it upcoming', () {
      final snoozed = reminder(
        date: day,
        snoozedUntil: DateTime(2026, 10, 14, 9, 10),
      );
      expect(snoozed.isUpcoming(DateTime(2026, 10, 14, 9, 5)), isTrue);
    });
  });

  group('daily', () {
    final r = reminder(date: day, recurrence: RecurrenceRule.daily);

    test('later today, else tomorrow', () {
      expect(
        r.nextOccurrence(DateTime(2026, 10, 15, 8)),
        DateTime(2026, 10, 15, 9),
      );
      expect(
        r.nextOccurrence(DateTime(2026, 10, 15, 10)),
        DateTime(2026, 10, 16, 9),
      );
    });

    test('occurrences in a window', () {
      expect(
        r.occurrencesBetween(
          DateTime(2026, 10, 14, 10),
          DateTime(2026, 10, 16, 9),
        ),
        [DateTime(2026, 10, 15, 9), DateTime(2026, 10, 16, 9)],
      );
    });

    test('disabled reminders are never upcoming', () {
      expect(
        reminder(
          date: day,
          recurrence: RecurrenceRule.daily,
          enabled: false,
        ).isUpcoming(day),
        isFalse,
      );
    });
  });

  test('weekly on Mondays skips other days', () {
    const mondays = RecurrenceRule(
      frequency: RecurrenceFrequency.weekly,
      weekdays: {DateTime.monday},
    );
    final r = reminder(date: day, recurrence: mondays);
    expect(
      r.nextOccurrence(DateTime(2026, 10, 14, 8)),
      DateTime(2026, 10, 19, 9),
    );
  });
}
