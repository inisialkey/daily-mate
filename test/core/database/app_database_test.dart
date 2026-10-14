import 'dart:io';

import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  test('creates the single settings rows on open, once', () async {
    expect(await db.select(db.appSettingsTable).get(), hasLength(1));
    expect(await db.select(db.prayerSettingsTable).get(), hasLength(1));
    final prefs = await db.select(db.prayerPreferences).get();
    expect(prefs.map((r) => r.prayer), unorderedEquals(PrayerName.values));
    expect(
      prefs.firstWhere((r) => r.prayer == PrayerName.sunrise).notify,
      isFalse,
    );
  });

  test('enforces foreign keys', () async {
    final row = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(row.data.values.single, 1);
  });

  test('rejects values outside CHECK constraints', () async {
    await expectLater(
      db.customStatement(
        'UPDATE app_settings SET default_reminder_minutes = 2000',
      ),
      throwsA(anything),
    );
  });

  test('watchTables streams stay separate per table set', () async {
    // Regression: Drift shares stream queries with identical SQL, so a
    // second watcher once silently reused the first one's tables.
    final notesEvents = <void>[];
    final tasksEvents = <void>[];
    final a = db.watchTables({db.notes}).listen(notesEvents.add);
    final b = db.watchTables({db.tasks}).listen(tasksEvents.add);
    addTearDown(a.cancel);
    addTearDown(b.cancel);
    await pumpEventQueue();
    expect((notesEvents.length, tasksEvents.length), (1, 1));

    final now = DateTime(2026);
    await db
        .into(db.tasks)
        .insert(
          TasksCompanion.insert(title: 't', createdAt: now, updatedAt: now),
        );
    await pumpEventQueue();
    expect((notesEvents.length, tasksEvents.length), (1, 2));
  });

  test('backupTo writes a database file', () async {
    final dir = await Directory.systemTemp.createTemp('dailymate_backup');
    addTearDown(() => dir.delete(recursive: true));
    final target = p.join(dir.path, 'backup.sqlite');
    await db.backupTo(target);
    expect(File(target).lengthSync(), greaterThan(0));
  });
}
