import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/features/settings/domain/app_settings.dart';
import 'package:daily_mate/features/settings/domain/app_theme_mode.dart';
import 'package:daily_mate/features/settings/domain/settings_repository.dart';
import 'package:drift/drift.dart';

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$AppSettingsTableTable, AppSettingsRow> get _row =>
      _db.select(_db.appSettingsTable)..where((t) => t.id.equals(1));

  @override
  Future<AppSettings> load() async => _toEntity(await _row.getSingle());

  @override
  Stream<AppSettings> watch() => _row.watchSingle().map(_toEntity);

  @override
  Future<void> setThemeMode(AppThemeMode mode) =>
      _write(AppSettingsTableCompanion(themeMode: Value(mode)));

  @override
  Future<void> setSidebarCollapsed({required bool collapsed}) =>
      _write(AppSettingsTableCompanion(sidebarCollapsed: Value(collapsed)));

  @override
  Future<void> setDefaultReminderMinutes(int minutes) => _write(
    AppSettingsTableCompanion(defaultReminderMinutes: Value(minutes)),
  );

  @override
  Future<void> setWelcomeDismissed() => _write(
    const AppSettingsTableCompanion(welcomeDismissed: Value(true)),
  );

  @override
  Future<void> setNotificationsCheckedAt(DateTime at) => _write(
    AppSettingsTableCompanion(notificationsCheckedAt: Value(at)),
  );

  Future<void> _write(AppSettingsTableCompanion changes) => (_db.update(
    _db.appSettingsTable,
  )..where((t) => t.id.equals(1))).write(changes);

  AppSettings _toEntity(AppSettingsRow row) => AppSettings(
    themeMode: row.themeMode,
    sidebarCollapsed: row.sidebarCollapsed,
    defaultReminderMinutes: row.defaultReminderMinutes,
    welcomeDismissed: row.welcomeDismissed,
    notificationsCheckedAt: row.notificationsCheckedAt,
  );
}
