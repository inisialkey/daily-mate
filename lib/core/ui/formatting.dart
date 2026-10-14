import 'package:daily_mate/core/utils/dates.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String greetingFor(DateTime now) => switch (now.hour) {
  >= 4 && < 12 => 'Good morning',
  >= 12 && < 17 => 'Good afternoon',
  _ => 'Good evening',
};

/// "Wednesday, 14 October"
String formatLongDate(DateTime date) => DateFormat('EEEE, d MMMM').format(date);

/// Follows the Mac's 12/24-hour preference.
String formatTime(BuildContext context, DateTime time) =>
    MediaQuery.alwaysUse24HourFormatOf(context)
    ? DateFormat.Hm().format(time)
    : DateFormat.jm().format(time);

String formatMinutesOfDay(BuildContext context, int minutes) =>
    formatTime(context, atMinutes(DateTime(2000), minutes));

/// "Today", "Tomorrow", "Yesterday", a weekday within the coming week, or a
/// short date ("14 Oct", "14 Oct 2027" outside the current year).
String formatRelativeDay(DateTime date, DateTime today) {
  final days = epochDay(date) - epochDay(today);
  return switch (days) {
    0 => 'Today',
    1 => 'Tomorrow',
    -1 => 'Yesterday',
    > 1 && < 7 => DateFormat.EEEE().format(date),
    _ =>
      date.year == today.year
          ? DateFormat('d MMM').format(date)
          : DateFormat('d MMM y').format(date),
  };
}

/// "2h 05m", "45m", "under a minute".
String formatShortDuration(Duration duration) {
  final minutes = duration.inMinutes;
  if (minutes < 1) return 'under a minute';
  if (minutes < 60) return '${minutes}m';
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '${minutes ~/ 60}h ${m}m';
}

/// "01:23:45" for live countdowns.
String formatCountdown(Duration duration) {
  final seconds = duration.inSeconds < 0 ? 0 : duration.inSeconds;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(seconds ~/ 3600)}:${two(seconds % 3600 ~/ 60)}:'
      '${two(seconds % 60)}';
}

/// "Today 09:00", "Tomorrow 18:30", "Friday 07:00", "2 Nov 09:00".
String formatWhen(BuildContext context, DateTime at, DateTime now) {
  final day = formatRelativeDay(dateOnly(at), dateOnly(now));
  return '$day ${formatTime(context, at)}';
}
