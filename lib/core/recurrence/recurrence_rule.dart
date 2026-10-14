import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurrence_rule.freezed.dart';

/// Stored by name (Drift `textEnum`).
enum RecurrenceFrequency { daily, weekly, monthly, yearly }

@freezed
abstract class RecurrenceRule with _$RecurrenceRule {
  const factory RecurrenceRule({
    required RecurrenceFrequency frequency,
    @Default(1) int interval,

    /// ISO weekdays (`DateTime.monday`..`DateTime.sunday`) for weekly rules.
    /// Empty means "the anchor's weekday".
    @Default(<int>{}) Set<int> weekdays,

    /// Last date (inclusive) an occurrence may fall on.
    DateTime? until,
  }) = _RecurrenceRule;

  static const daily = RecurrenceRule(frequency: RecurrenceFrequency.daily);
  static const weekdaysOnly = RecurrenceRule(
    frequency: RecurrenceFrequency.weekly,
    weekdays: {1, 2, 3, 4, 5},
  );
  static const weekly = RecurrenceRule(frequency: RecurrenceFrequency.weekly);
  static const monthly = RecurrenceRule(frequency: RecurrenceFrequency.monthly);
  static const yearly = RecurrenceRule(frequency: RecurrenceFrequency.yearly);
}

/// Weekday set <-> bitmask (Monday = bit 0) for storage.
int weekdaysToMask(Set<int> weekdays) =>
    weekdays.fold(0, (mask, day) => mask | (1 << (day - 1)));

Set<int> weekdaysFromMask(int mask) => {
  for (var day = DateTime.monday; day <= DateTime.sunday; day++)
    if (mask & (1 << (day - 1)) != 0) day,
};
