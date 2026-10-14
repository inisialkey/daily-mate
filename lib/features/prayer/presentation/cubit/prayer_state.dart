part of 'prayer_cubit.dart';

@freezed
sealed class PrayerState with _$PrayerState {
  const factory PrayerState.loading() = PrayerLoading;
  const factory PrayerState.needsLocation(PrayerSettings settings) =
      PrayerNeedsLocation;
  const factory PrayerState.ready({
    required PrayerSettings settings,
    required PrayerDay today,
    required PrayerTime next,

    /// The prayer whose time is running now, if any.
    required PrayerName? current,
  }) = PrayerReady;
  const factory PrayerState.error(String message) = PrayerError;
}
