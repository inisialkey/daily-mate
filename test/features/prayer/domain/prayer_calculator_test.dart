import 'package:daily_mate/features/prayer/domain/prayer_calculator.dart';
import 'package:daily_mate/features/prayer/domain/prayer_method.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/domain/prayer_settings.dart';
import 'package:flutter_test/flutter_test.dart';

const jakarta = PrayerSettings(
  latitude: -6.2088,
  longitude: 106.8456,
  locationName: 'Jakarta',
);

/// Minutes after 00:00 UTC, so assertions don't depend on the test
/// machine's time zone.
int utcMinutes(DateTime t) {
  final u = t.toUtc();
  return u.hour * 60 + u.minute;
}

void main() {
  final calculator = PrayerCalculator();
  final date = DateTime(2026, 10, 14);

  test('Jakarta, Kemenag: times are in order and physically plausible', () {
    final day = calculator.day(jakarta, date);
    final times = [for (final name in PrayerName.values) day[name]];
    for (var i = 1; i < times.length; i++) {
      expect(times[i].isAfter(times[i - 1]), isTrue, reason: '$i');
    }
    // Solar noon in Jakarta mid-October ≈ 04:39 UTC (11:39 WIB); Kemenag
    // adds 1 minute to Dhuhr.
    expect(
      utcMinutes(day[PrayerName.dhuhr]),
      inInclusiveRange(4 * 60 + 37, 4 * 60 + 43),
    );
    // Near the equator day and night are ~12 h: sunrise ≈ 05:30 WIB,
    // maghrib ≈ 17:50 WIB.
    expect(
      utcMinutes(day[PrayerName.sunrise]),
      inInclusiveRange(22 * 60 + 20, 22 * 60 + 45),
    );
    expect(
      utcMinutes(day[PrayerName.maghrib]),
      inInclusiveRange(10 * 60 + 40, 11 * 60 + 5),
    );
  });

  test('a 20° Fajr (Kemenag) is earlier than an 18° Fajr (MWL)', () {
    final kemenag = calculator.day(jakarta, date)[PrayerName.fajr];
    final mwl = calculator.day(
      jakarta.copyWith(method: PrayerMethod.muslimWorldLeague),
      date,
    )[PrayerName.fajr];
    final diff = mwl.difference(kemenag).inMinutes;
    expect(diff, inInclusiveRange(6, 12));
  });

  test('Hanafi Asr comes later than the standard Asr', () {
    final standard = calculator.day(jakarta, date)[PrayerName.asr];
    final hanafi = calculator.day(
      jakarta.copyWith(asrMethod: AsrMethod.hanafi),
      date,
    )[PrayerName.asr];
    expect(hanafi.difference(standard).inMinutes, inInclusiveRange(30, 75));
  });

  test('per-prayer adjustments shift exactly that many minutes', () {
    final base = calculator.day(jakarta, date);
    final adjusted = calculator.day(
      jakarta.copyWith(
        preferences: {
          PrayerName.fajr: const PrayerPreference(adjustmentMinutes: 2),
          PrayerName.isha: const PrayerPreference(adjustmentMinutes: -3),
        },
      ),
      date,
    );
    expect(
      adjusted[PrayerName.fajr].difference(base[PrayerName.fajr]),
      const Duration(minutes: 2),
    );
    expect(
      adjusted[PrayerName.isha].difference(base[PrayerName.isha]),
      const Duration(minutes: -3),
    );
    expect(adjusted[PrayerName.dhuhr], base[PrayerName.dhuhr]);
  });

  test('high latitudes still produce an ordered schedule (London, June)', () {
    const london = PrayerSettings(
      latitude: 51.5072,
      longitude: -0.1276,
      method: PrayerMethod.muslimWorldLeague,
      highLatitudeMode: HighLatitudeMode.seventhOfTheNight,
    );
    final day = calculator.day(london, DateTime(2026, 6, 21));
    final times = [for (final name in PrayerName.values) day[name]];
    for (var i = 1; i < times.length; i++) {
      expect(times[i].isAfter(times[i - 1]), isTrue);
    }
  });

  test('cache returns the same day until settings change', () {
    final a = calculator.day(jakarta, date);
    expect(identical(calculator.day(jakarta, date), a), isTrue);
    final b = calculator.day(
      jakarta.copyWith(method: PrayerMethod.karachi),
      date,
    );
    expect(identical(a, b), isFalse);
  });

  test('next prayer rolls over to tomorrow after Isha', () {
    final day = calculator.day(jakarta, date);
    final lateNight = day[PrayerName.isha].add(const Duration(minutes: 5));
    final next = calculator.next(jakarta, lateNight);
    expect(next.name, PrayerName.fajr);
    expect(next.at.isAfter(lateNight), isTrue);
    expect(next.at.difference(lateNight).inHours, lessThan(12));
  });

  test('current prayer: Subuh until sunrise, none until Zuhur, then Isya', () {
    final day = calculator.day(jakarta, date);
    const minute = Duration(minutes: 1);
    expect(day.currentAt(day[PrayerName.fajr].add(minute)), PrayerName.fajr);
    expect(day.currentAt(day[PrayerName.sunrise].add(minute)), isNull);
    expect(day.currentAt(day[PrayerName.dhuhr].add(minute)), PrayerName.dhuhr);
    expect(day.currentAt(day[PrayerName.isha].add(minute)), PrayerName.isha);
    expect(day.currentAt(day[PrayerName.fajr].subtract(minute)), isNull);
  });

  test('without a location there is nothing to calculate', () {
    expect(
      () => calculator.day(const PrayerSettings(), date),
      throwsStateError,
    );
  });
}
