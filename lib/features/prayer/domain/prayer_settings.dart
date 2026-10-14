import 'package:daily_mate/features/prayer/domain/prayer_method.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_settings.freezed.dart';

@freezed
abstract class PrayerPreference with _$PrayerPreference {
  const factory PrayerPreference({
    /// Minutes added to the calculated time (negative = earlier).
    @Default(0) int adjustmentMinutes,
    @Default(true) bool notify,

    /// Extra alert this many minutes before; 0 = none.
    @Default(0) int advanceMinutes,
    @Default(true) bool sound,
  }) = _PrayerPreference;
}

@freezed
abstract class PrayerSettings with _$PrayerSettings {
  const factory PrayerSettings({
    double? latitude,
    double? longitude,
    String? locationName,
    @Default(PrayerMethod.kemenag) PrayerMethod method,
    @Default(AsrMethod.standard) AsrMethod asrMethod,
    @Default(HighLatitudeMode.middleOfTheNight)
    HighLatitudeMode highLatitudeMode,
    @Default(<PrayerName, PrayerPreference>{})
    Map<PrayerName, PrayerPreference> preferences,
  }) = _PrayerSettings;

  const PrayerSettings._();

  bool get hasLocation => latitude != null && longitude != null;

  PrayerPreference preference(PrayerName prayer) =>
      preferences[prayer] ?? PrayerPreference(notify: prayer.isPrayer);
}
