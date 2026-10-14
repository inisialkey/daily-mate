import 'package:daily_mate/core/recurrence/recurrence.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder.freezed.dart';

/// A standalone reminder. Times are a local date plus minutes after
/// midnight, so a daily 09:00 reminder follows the Mac's wall clock.
@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    required int id,
    required String title,
    required DateTime date,
    required int minutes,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String notes,
    RecurrenceRule? recurrence,
    @Default(true) bool enabled,
    DateTime? snoozedUntil,

    /// One-time reminders only: marked done.
    DateTime? completedAt,
  }) = _Reminder;

  const Reminder._();

  bool get isRecurring => recurrence != null;

  /// First (or only) occurrence.
  DateTime get startAt => atMinutes(date, minutes);

  /// Occurrence instants within [from]..[to] (inclusive), ignoring
  /// enabled/done state.
  List<DateTime> occurrencesBetween(DateTime from, DateTime to) {
    final rule = recurrence;
    if (rule == null) {
      final at = startAt;
      return at.isBefore(from) || at.isAfter(to) ? const [] : [at];
    }
    return [
      for (final day in Recurrence.between(
        rule,
        anchor: date,
        from: dateOnly(from),
        to: dateOnly(to),
      ))
        if (atMinutes(day, minutes) case final at
            when !at.isBefore(from) && !at.isAfter(to))
          at,
    ];
  }

  /// The next occurrence strictly after [after], or null when none is left.
  DateTime? nextOccurrence(DateTime after) {
    final rule = recurrence;
    if (rule == null) return startAt.isAfter(after) ? startAt : null;
    final today = dateOnly(after);
    final sameDay = atMinutes(today, minutes);
    if (sameDay.isAfter(after) &&
        Recurrence.between(
          rule,
          anchor: date,
          from: today,
          to: today,
        ).isNotEmpty) {
      return sameDay;
    }
    final next = Recurrence.nextAfter(rule, anchor: date, after: today);
    return next == null ? null : atMinutes(next, minutes);
  }

  /// Will still alert at some point after [now].
  bool isUpcoming(DateTime now) {
    if (!enabled || completedAt != null) return false;
    final snooze = snoozedUntil;
    return (snooze != null && snooze.isAfter(now)) ||
        nextOccurrence(now) != null;
  }

  /// A one-time reminder whose moment passed without being marked done.
  bool isPast(DateTime now) =>
      !isRecurring && completedAt == null && !startAt.isAfter(now);
}
