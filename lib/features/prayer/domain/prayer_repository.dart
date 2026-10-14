import 'package:daily_mate/features/prayer/domain/prayer_method.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/domain/prayer_settings.dart';

abstract interface class PrayerRepository {
  Future<PrayerSettings> settings();

  Stream<PrayerSettings> watchSettings();

  Future<void> setLocation({
    required double latitude,
    required double longitude,
    required String name,
  });

  Future<void> setMethod(PrayerMethod method);

  Future<void> setAsrMethod(AsrMethod method);

  Future<void> setHighLatitudeMode(HighLatitudeMode mode);

  Future<void> setPreference(PrayerName prayer, PrayerPreference preference);
}
