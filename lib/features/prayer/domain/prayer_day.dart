import 'package:daily_mate/features/prayer/domain/prayer_name.dart';

typedef PrayerTime = ({PrayerName name, DateTime at});

/// One day's schedule in local time, adjustments applied.
class PrayerDay {
  const PrayerDay({required this.date, required this.times});

  final DateTime date;
  final Map<PrayerName, DateTime> times;

  DateTime operator [](PrayerName name) => times[name]!;

  /// The five prayers in order (sunrise excluded).
  List<PrayerTime> get prayers => [
    for (final name in PrayerName.prayers) (name: name, at: times[name]!),
  ];

  /// First prayer strictly after [now] on this day, if any.
  PrayerTime? nextAfter(DateTime now) =>
      prayers.where((p) => p.at.isAfter(now)).firstOrNull;

  /// The prayer whose time has begun and not yet been followed by the next
  /// one (Subuh ends at sunrise).
  PrayerName? currentAt(DateTime now) {
    final fajr = times[PrayerName.fajr]!;
    if (now.isBefore(fajr)) return null;
    if (now.isBefore(times[PrayerName.sunrise]!)) return PrayerName.fajr;
    final started = prayers.where((p) => !p.at.isAfter(now)).lastOrNull;
    return started?.name == PrayerName.fajr ? null : started?.name;
  }
}
