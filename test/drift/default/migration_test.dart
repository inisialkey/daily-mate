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

  test('a new database matches the v1 snapshot exactly', () async {
    final db = AppDatabase(await verifier.startAt(1));
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 1);
  });
}
