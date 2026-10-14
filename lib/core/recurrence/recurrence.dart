import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/utils/dates.dart';

/// Occurrence arithmetic on calendar dates.
///
/// A series starts at its anchor; every occurrence is derived from the anchor,
/// never from the previous occurrence, so "the 31st of every month" lands on
/// the last day of short months and returns to the 31st afterwards.
abstract final class Recurrence {
  /// Hard cap for [between], so no rule can produce an unbounded list.
  static const int maxOccurrences = 1000;

  /// The first occurrence strictly after [after] (time of day ignored), or
  /// null when the series has ended.
  static DateTime? nextAfter(
    RecurrenceRule rule, {
    required DateTime anchor,
    required DateTime after,
  }) {
    final first = dateOnly(anchor);
    final dayAfter = addDays(dateOnly(after), 1);
    final start = dayAfter.isBefore(first) ? first : dayAfter;
    final interval = rule.interval < 1 ? 1 : rule.interval;
    final next = switch (rule.frequency) {
      RecurrenceFrequency.daily => _daily(first, start, interval),
      RecurrenceFrequency.weekly => _weekly(rule, first, start, interval),
      RecurrenceFrequency.monthly => _monthly(first, start, interval),
      RecurrenceFrequency.yearly => _monthly(first, start, interval * 12),
    };
    final until = rule.until;
    return until != null && next.isAfter(dateOnly(until)) ? null : next;
  }

  /// Due date of the occurrence that replaces one due on [due] when it is
  /// completed on [today]. Occurrences already in the past are skipped, so
  /// a daily task finished three days late comes back today, not in the past.
  static DateTime? nextDueAfterCompletion(
    RecurrenceRule rule, {
    required DateTime anchor,
    required DateTime due,
    required DateTime today,
  }) {
    final after = due.isBefore(today) ? addDays(today, -1) : due;
    return nextAfter(rule, anchor: anchor, after: after);
  }

  /// Occurrences within [from]..[to], both inclusive.
  static Iterable<DateTime> between(
    RecurrenceRule rule, {
    required DateTime anchor,
    required DateTime from,
    required DateTime to,
  }) sync* {
    var next = nextAfter(rule, anchor: anchor, after: addDays(from, -1));
    var count = 0;
    while (next != null && !next.isAfter(to) && count < maxOccurrences) {
      yield next;
      count++;
      next = nextAfter(rule, anchor: anchor, after: next);
    }
  }

  static DateTime _daily(DateTime first, DateTime start, int interval) {
    final diff = epochDay(start) - epochDay(first);
    final steps = (diff + interval - 1) ~/ interval;
    return fromEpochDay(epochDay(first) + steps * interval);
  }

  static DateTime _weekly(
    RecurrenceRule rule,
    DateTime first,
    DateTime start,
    int interval,
  ) {
    final days = rule.weekdays.isEmpty ? {first.weekday} : rule.weekdays;
    final firstWeek = epochDay(startOfWeek(first));
    var day = epochDay(start);
    // A match always exists within `interval` weeks plus the current one.
    for (var i = 0; i < 7 * (interval + 1); i++, day++) {
      final date = fromEpochDay(day);
      final weekIndex = (epochDay(startOfWeek(date)) - firstWeek) ~/ 7;
      if (weekIndex % interval == 0 && days.contains(date.weekday)) {
        return date;
      }
    }
    throw StateError('No weekly occurrence found for $rule');
  }

  static DateTime _monthly(DateTime first, DateTime start, int stepMonths) {
    final months = (start.year - first.year) * 12 + (start.month - first.month);
    var step = months ~/ stepMonths;
    while (true) {
      final candidate = _monthOccurrence(first, step * stepMonths);
      if (!candidate.isBefore(start)) return candidate;
      step++;
    }
  }

  static DateTime _monthOccurrence(DateTime first, int offset) {
    final monthIndex = first.month - 1 + offset;
    final year = first.year + monthIndex ~/ 12;
    final month = monthIndex % 12 + 1;
    final last = daysInMonth(year, month);
    return DateTime(year, month, first.day > last ? last : first.day);
  }
}
