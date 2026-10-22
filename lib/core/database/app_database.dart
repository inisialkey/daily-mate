import 'package:daily_mate/core/database/converters.dart';
import 'package:daily_mate/core/database/tables.dart';
import 'package:daily_mate/core/recurrence/recurrence_rule.dart';
import 'package:daily_mate/features/prayer/domain/prayer_method.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/reminders/domain/reminder_event_kind.dart';
import 'package:daily_mate/features/settings/domain/app_theme_mode.dart';
import 'package:daily_mate/features/tasks/domain/priority.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Tasks,
    Subtasks,
    Tags,
    TaskTags,
    Notes,
    NoteTags,
    Reminders,
    ReminderEvents,
    PrayerSettingsTable,
    PrayerPreferences,
    AppSettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// The on-disk database in the app's Application Support directory —
  /// never inside the app bundle, so replacing the app keeps the data.
  /// Queries run on a background isolate, shared with the menu bar
  /// popover's engine so a write in either shows up in both.
  factory AppDatabase.open() => AppDatabase(
    driftDatabase(
      name: fileName,
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
        shareAcrossIsolates: true,
      ),
    ),
  );

  static const fileName = 'dailymate';

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await _ensureSingletonRows();
    },
  );

  /// Idempotent: settings rows exist after every open, including after a
  /// future migration that adds a table.
  Future<void> _ensureSingletonRows() => transaction(() async {
    await into(prayerSettingsTable).insert(
      const PrayerSettingsTableCompanion(),
      mode: InsertMode.insertOrIgnore,
    );
    await into(appSettingsTable).insert(
      const AppSettingsTableCompanion(),
      mode: InsertMode.insertOrIgnore,
    );
    for (final prayer in PrayerName.values) {
      await into(prayerPreferences).insert(
        PrayerPreferencesCompanion.insert(
          prayer: prayer,
          notify: Value(prayer.isPrayer),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });

  /// Emits once immediately and again after every write to any of [tables].
  ///
  /// Drift shares stream queries with the same SQL and variables, so the
  /// table set is bound as a variable: without it every caller would get the
  /// first caller's stream and miss writes to its own tables.
  Stream<void> watchTables(
    Set<ResultSetImplementation<dynamic, dynamic>> tables,
  ) {
    final key = (tables.map((t) => t.entityName).toList()..sort()).join(',');
    return customSelect(
      'SELECT ?',
      variables: [Variable.withString(key)],
      readsFrom: tables,
    ).watch().map((_) {});
  }

  /// Writes a consistent snapshot of the whole database to [path].
  Future<void> backupTo(String path) =>
      customStatement('VACUUM INTO ?', [path]);
}
