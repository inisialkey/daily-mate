import 'package:daily_mate/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Fresh in-memory SQLite database (the real schema and migrations).
AppDatabase testDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
}
