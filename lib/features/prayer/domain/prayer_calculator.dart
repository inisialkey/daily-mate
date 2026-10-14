import 'package:adhan_dart/adhan_dart.dart';
import 'package:daily_mate/core/utils/dates.dart';
import 'package:daily_mate/features/prayer/domain/prayer_day.dart';
import 'package:daily_mate/features/prayer/domain/prayer_method.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/domain/prayer_settings.dart';

/// Computes prayer times locally with adhan_dart — no network. Results are
/// cached per (settings, date); any settings change misses the cache.
class PrayerCalculator {
  static const int _cacheSize = 64;
  // Map literals keep insertion order: the first key is the oldest.
  final _cache = <(PrayerSettings, DateTime), PrayerDay>{};

  /// Times for [date] (a calendar day), in this Mac's time zone.
  PrayerDay day(PrayerSettings settings, DateTime date) {
    final latitude = settings.latitude;
    final longitude = settings.longitude;
    if (latitude == null || longitude == null) {
      throw StateError('Prayer times need a location.');
    }
    final key = (settings, dateOnly(date));
    final cached = _cache.remove(key);
    if (cached != null) return _cache[key] = cached;

    final times = PrayerTimes(
      date: dateOnly(date),
      coordinates: Coordinates(latitude, longitude),
      calculationParameters: _parameters(settings),
    );
    final day = PrayerDay(
      date: dateOnly(date),
      times: {
        PrayerName.fajr: times.fajr.toLocal(),
        PrayerName.sunrise: times.sunrise.toLocal(),
        PrayerName.dhuhr: times.dhuhr.toLocal(),
        PrayerName.asr: times.asr.toLocal(),
        PrayerName.maghrib: times.maghrib.toLocal(),
        PrayerName.isha: times.isha.toLocal(),
      },
    );
    _cache[key] = day;
    if (_cache.length > _cacheSize) _cache.remove(_cache.keys.first);
    return day;
  }

  /// The next prayer after [now], looking into tomorrow after Isha.
  PrayerTime next(PrayerSettings settings, DateTime now) =>
      day(settings, now).nextAfter(now) ??
      day(settings, addDays(dateOnly(now), 1)).prayers.first;

  CalculationParameters _parameters(PrayerSettings s) {
    final params = switch (s.method) {
      PrayerMethod.kemenag => CalculationMethodParameters.indonesian(),
      PrayerMethod.singapore => CalculationMethodParameters.singapore(),
      PrayerMethod.muslimWorldLeague =>
        CalculationMethodParameters.muslimWorldLeague(),
      PrayerMethod.ummAlQura => CalculationMethodParameters.ummAlQura(),
      PrayerMethod.egyptian => CalculationMethodParameters.egyptian(),
      PrayerMethod.karachi => CalculationMethodParameters.karachi(),
      PrayerMethod.northAmerica => CalculationMethodParameters.northAmerica(),
      PrayerMethod.dubai => CalculationMethodParameters.dubai(),
      PrayerMethod.qatar => CalculationMethodParameters.qatar(),
      PrayerMethod.kuwait => CalculationMethodParameters.kuwait(),
      PrayerMethod.turkiye => CalculationMethodParameters.turkiye(),
      PrayerMethod.moonsightingCommittee =>
        CalculationMethodParameters.moonsightingCommittee(),
    };
    int adjustment(PrayerName name) => s.preference(name).adjustmentMinutes;
    return params
      ..madhab = s.asrMethod == AsrMethod.hanafi ? Madhab.hanafi : Madhab.shafi
      ..highLatitudeRule = switch (s.highLatitudeMode) {
        HighLatitudeMode.middleOfTheNight => HighLatitudeRule.middleOfTheNight,
        HighLatitudeMode.seventhOfTheNight =>
          HighLatitudeRule.seventhOfTheNight,
        HighLatitudeMode.twilightAngle => HighLatitudeRule.twilightAngle,
      }
      ..adjustments = {
        Prayer.fajr: adjustment(PrayerName.fajr),
        Prayer.sunrise: adjustment(PrayerName.sunrise),
        Prayer.dhuhr: adjustment(PrayerName.dhuhr),
        Prayer.asr: adjustment(PrayerName.asr),
        Prayer.maghrib: adjustment(PrayerName.maghrib),
        Prayer.isha: adjustment(PrayerName.isha),
      };
  }
}
