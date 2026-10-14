import 'package:collection/collection.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:intl/intl.dart';

const _weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// "Every 2 weeks on Mon, Thu until 31 Dec 2026"
String recurrenceLabel(RecurrenceRule rule) {
  final n = rule.interval;
  final base = switch (rule.frequency) {
    RecurrenceFrequency.daily => n == 1 ? 'Every day' : 'Every $n days',
    RecurrenceFrequency.weekly => _weekly(rule),
    RecurrenceFrequency.monthly => n == 1 ? 'Every month' : 'Every $n months',
    RecurrenceFrequency.yearly => n == 1 ? 'Every year' : 'Every $n years',
  };
  final until = rule.until;
  return until == null
      ? base
      : '$base until ${DateFormat('d MMM y').format(until)}';
}

/// Compact form for list rows: "Daily", "Weekdays", "Every 2 weeks".
String recurrenceShortLabel(RecurrenceRule rule) {
  if (rule.interval != 1) return recurrenceLabel(rule.copyWith(until: null));
  return switch (rule.frequency) {
    RecurrenceFrequency.daily => 'Daily',
    RecurrenceFrequency.weekly when _isWeekdays(rule) => 'Weekdays',
    RecurrenceFrequency.weekly => 'Weekly',
    RecurrenceFrequency.monthly => 'Monthly',
    RecurrenceFrequency.yearly => 'Yearly',
  };
}

bool _isWeekdays(RecurrenceRule rule) =>
    const SetEquality<int>().equals(rule.weekdays, {1, 2, 3, 4, 5});

String _weekly(RecurrenceRule rule) {
  if (rule.interval == 1 && _isWeekdays(rule)) return 'Every weekday';
  final every = rule.interval == 1
      ? 'Every week'
      : 'Every ${rule.interval} weeks';
  if (rule.weekdays.isEmpty) return every;
  final days = rule.weekdays.sorted((a, b) => a - b);
  return '$every on ${days.map((d) => _weekdayNames[d - 1]).join(', ')}';
}
