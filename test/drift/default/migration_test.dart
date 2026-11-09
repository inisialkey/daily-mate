import 'package:daily_mate/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

/// Schema snapshots live in `drift_schemas/`. After bumping
/// `schemaVersion`: `dart run drift_dev make-migrations`, then add a
/// `migrateAndValidate` test from every older version to the new one.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('v1 upgrades to the current schema', () async {
    final db = AppDatabase(await verifier.startAt(1));
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 2);
  });

  test('upgrading from v1 keeps tasks and leaves them To Do', () async {
    final schema = await verifier.schemaAt(1);
    schema.rawDatabase.execute(
      "INSERT INTO tasks (title, created_at, updated_at) VALUES ('Old', 0, 0)",
    );
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 2);

    final row = await db.select(db.tasks).getSingle();
    expect(row.title, 'Old');
    expect(row.inProgress, isFalse);
  });
}
