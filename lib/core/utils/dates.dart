/// Calendar helpers. A "date" is a local `DateTime` at midnight; arithmetic
/// goes through the `DateTime` constructor (or UTC epoch days) so a daylight
/// saving transition can never shift the calendar day.
library;

const int _msPerDay = Duration.millisecondsPerDay;

DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime addDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

/// Days since 1970-01-01 for the calendar date of [date].
int epochDay(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/
    _msPerDay;

DateTime fromEpochDay(int day) {
  final utc = DateTime.fromMillisecondsSinceEpoch(day * _msPerDay, isUtc: true);
  return DateTime(utc.year, utc.month, utc.day);
}

/// Local date-time [minutes] after midnight of [date].
DateTime atMinutes(DateTime date, int minutes) =>
    DateTime(date.year, date.month, date.day, minutes ~/ 60, minutes % 60);

int minutesOfDay(DateTime value) => value.hour * 60 + value.minute;

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Monday of the week containing [date].
DateTime startOfWeek(DateTime date) => addDays(date, 1 - date.weekday);
