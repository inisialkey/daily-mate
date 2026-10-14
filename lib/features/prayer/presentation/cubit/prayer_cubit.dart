import 'dart:async';

import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/core/utils/app_clock.dart';
import 'package:daily_mate/core/utils/streams.dart';
import 'package:daily_mate/features/prayer/domain/city_catalog.dart';
import 'package:daily_mate/features/prayer/domain/location_service.dart';
import 'package:daily_mate/features/prayer/domain/prayer_calculator.dart';
import 'package:daily_mate/features/prayer/domain/prayer_day.dart';
import 'package:daily_mate/features/prayer/domain/prayer_method.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/domain/prayer_repository.dart';
import 'package:daily_mate/features/prayer/domain/prayer_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_cubit.freezed.dart';
part 'prayer_state.dart';

/// App-scoped: today's schedule and the next prayer, recomputed when the
/// settings change and as time passes.
class PrayerCubit extends Cubit<PrayerState> {
  PrayerCubit(this._prayers, this._calculator, this._location, AppClock clock)
    : super(const PrayerState.loading()) {
    _subscription =
        combineLatest2(
          _prayers.watchSettings(),
          clock.watchNow(),
          _compute,
        ).listen(
          emit,
          onError: (Object error, StackTrace stack) {
            AppLogger.e('Prayer times failed', error, stack);
            emit(const PrayerState.error("Couldn't calculate prayer times."));
          },
        );
  }

  final PrayerRepository _prayers;
  final PrayerCalculator _calculator;
  final LocationService _location;
  late final StreamSubscription<PrayerState> _subscription;

  PrayerState _compute(PrayerSettings settings, DateTime now) {
    if (!settings.hasLocation) return PrayerState.needsLocation(settings);
    final today = _calculator.day(settings, now);
    return PrayerState.ready(
      settings: settings,
      today: today,
      next: _calculator.next(settings, now),
      current: today.currentAt(now),
    );
  }

  /// Schedule of any day, for browsing dates.
  PrayerDay? dayFor(DateTime date) {
    final current = state;
    return current is PrayerReady
        ? _calculator.day(current.settings, date)
        : null;
  }

  List<City> searchCities(String query) => CityCatalog.search(query);

  Future<void> chooseCity(City city) => _prayers.setLocation(
    latitude: city.latitude,
    longitude: city.longitude,
    name: city.name,
  );

  Future<void> setCoordinates({
    required double latitude,
    required double longitude,
    required String name,
  }) => _prayers.setLocation(
    latitude: latitude,
    longitude: longitude,
    name: name,
  );

  /// Reads one position fix (asking permission the first time) and names
  /// it after the nearest listed city. Returns why it failed, or null.
  Future<LocationFailure?> useCurrentLocation() async {
    final result = await _location.currentLocation();
    final latitude = result.latitude;
    final longitude = result.longitude;
    if (latitude == null || longitude == null) {
      return result.failure ?? LocationFailure.unavailable;
    }
    final near = CityCatalog.nearest(latitude, longitude);
    await _prayers.setLocation(
      latitude: latitude,
      longitude: longitude,
      name: near == null ? 'Current location' : 'Near ${near.name}',
    );
    return null;
  }

  Future<void> setMethod(PrayerMethod method) => _prayers.setMethod(method);

  Future<void> setAsrMethod(AsrMethod method) => _prayers.setAsrMethod(method);

  Future<void> setHighLatitudeMode(HighLatitudeMode mode) =>
      _prayers.setHighLatitudeMode(mode);

  Future<void> updatePreference(
    PrayerName prayer,
    PrayerPreference Function(PrayerPreference current) change,
  ) async {
    final current = state;
    final settings = switch (current) {
      PrayerReady(:final settings) => settings,
      PrayerNeedsLocation(:final settings) => settings,
      _ => await _prayers.settings(),
    };
    await _prayers.setPreference(prayer, change(settings.preference(prayer)));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
