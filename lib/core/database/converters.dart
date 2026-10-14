import 'package:drift/drift.dart';

/// A calendar date stored as `yyyy-MM-dd` text: sorts lexically and never
/// shifts when the Mac's time zone changes. Instants (created/updated/
/// completed, notification times) use Drift's default UTC epoch seconds.
class DateOnlyConverter extends TypeConverter<DateTime, String> {
  const DateOnlyConverter();

  static String format(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  @override
  DateTime fromSql(String fromDb) {
    final parts = fromDb.split('-').map(int.parse).toList();
    return DateTime(parts[0], parts[1], parts[2]);
  }

  @override
  String toSql(DateTime value) => format(value);
}
