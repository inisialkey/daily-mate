import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/features/prayer/domain/prayer_method.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/domain/prayer_repository.dart';
import 'package:daily_mate/features/prayer/domain/prayer_settings.dart';
import 'package:drift/drift.dart';

class DriftPrayerRepository implements PrayerRepository {
  DriftPrayerRepository(this._db);

  final AppDatabase _db;

  @override
  Future<PrayerSettings> settings() async {
    final row = await (_db.select(
      _db.prayerSettingsTable,
    )..where((t) => t.id.equals(1))).getSingle();
    final prefs = await _db.select(_db.prayerPreferences).get();
    return PrayerSettings(
      latitude: row.latitude,
      longitude: row.longitude,
      locationName: row.locationName,
      method: row.method,
      asrMethod: row.asrMethod,
      highLatitudeMode: row.highLatitudeMode,
      preferences: {
        for (final p in prefs)
          p.prayer: PrayerPreference(
            adjustmentMinutes: p.adjustmentMinutes,
            notify: p.notify,
            advanceMinutes: p.advanceMinutes,
            sound: p.sound,
          ),
      },
    );
  }

  @override
  Stream<PrayerSettings> watchSettings() => _db
      .watchTables({_db.prayerSettingsTable, _db.prayerPreferences})
      .asyncMap((_) => settings());

  @override
  Future<void> setLocation({
    required double latitude,
    required double longitude,
    required String name,
  }) => _write(
    PrayerSettingsTableCompanion(
      latitude: Value(latitude),
      longitude: Value(longitude),
      locationName: Value(name.trim()),
    ),
  );

  @override
  Future<void> setMethod(PrayerMethod method) =>
      _write(PrayerSettingsTableCompanion(method: Value(method)));

  @override
  Future<void> setAsrMethod(AsrMethod method) =>
      _write(PrayerSettingsTableCompanion(asrMethod: Value(method)));

  @override
  Future<void> setHighLatitudeMode(HighLatitudeMode mode) =>
      _write(PrayerSettingsTableCompanion(highLatitudeMode: Value(mode)));

  @override
  Future<void> setPreference(PrayerName prayer, PrayerPreference p) => _db
      .into(_db.prayerPreferences)
      .insertOnConflictUpdate(
        PrayerPreferencesCompanion.insert(
          prayer: prayer,
          adjustmentMinutes: Value(p.adjustmentMinutes.clamp(-60, 60)),
          notify: Value(p.notify),
          advanceMinutes: Value(p.advanceMinutes.clamp(0, 120)),
          sound: Value(p.sound),
        ),
      );

  Future<void> _write(PrayerSettingsTableCompanion changes) => (_db.update(
    _db.prayerSettingsTable,
  )..where((t) => t.id.equals(1))).write(changes);
}
