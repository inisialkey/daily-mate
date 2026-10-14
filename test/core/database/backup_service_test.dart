import 'dart:io';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/core/database/backup_service.dart';
import 'package:daily_mate/features/tasks/data/drift_task_repository.dart';
import 'package:daily_mate/features/tasks/domain/task_draft.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late Directory dir;
  late AppDatabase db;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('dailymate_backup_test');
    db = testDatabase();
  });
  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  test('a backup is a complete, openable database', () async {
    await DriftTaskRepository(db).create(const TaskDraft(title: 'Keep me'));
    final service = BackupService(db, directory: () async => dir);

    final file = await service.backUp();
    final copy = AppDatabase(NativeDatabase(file));
    addTearDown(copy.close);
    expect((await copy.select(copy.tasks).get()).single.title, 'Keep me');
  });

  test('only the newest backups are kept', () async {
    final service = BackupService(db, directory: () async => dir, keep: 2);
    for (var minute = 0; minute < 4; minute++) {
      await withClock(
        Clock.fixed(DateTime(2026, 10, 14, 9, minute)),
        service.backUp,
      );
    }
    final names = Directory(
      '${dir.path}/Backups',
    ).listSync().map((f) => f.uri.pathSegments.last).toList()..sort();
    expect(names, [
      'dailymate-20261014-090200.sqlite',
      'dailymate-20261014-090300.sqlite',
    ]);
  });

  test('database path points into the app support directory', () async {
    final service = BackupService(db, directory: () async => dir);
    expect(await service.databasePath(), '${dir.path}/dailymate.sqlite');
  });
}
