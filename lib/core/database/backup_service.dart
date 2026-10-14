import 'dart:io';

import 'package:clock/clock.dart';
import 'package:daily_mate/core/database/app_database.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Consistent copies of the database (`VACUUM INTO`, safe while the app
/// runs) in Application Support/Backups. Keeps the newest [keep].
class BackupService {
  BackupService(
    this._db, {
    this._directory = getApplicationSupportDirectory,
    this.keep = 10,
  });

  final AppDatabase _db;
  final Future<Directory> Function() _directory;
  final int keep;

  Future<String> databasePath() async =>
      p.join((await _directory()).path, '${AppDatabase.fileName}.sqlite');

  Future<File> backUp() async {
    final folder = Directory(p.join((await _directory()).path, 'Backups'))
      ..createSync(recursive: true);
    final stamp = DateFormat('yyyyMMdd-HHmmss').format(clock.now());
    final file = File(p.join(folder.path, 'dailymate-$stamp.sqlite'));
    if (file.existsSync()) file.deleteSync();
    await _db.backupTo(file.path);

    final backups =
        folder
            .listSync()
            .whereType<File>()
            .where((f) => p.basename(f.path).startsWith('dailymate-'))
            .toList()
          ..sort((a, b) => b.path.compareTo(a.path));
    for (final old in backups.skip(keep)) {
      old.deleteSync();
    }
    return file;
  }
}
