import 'package:daily_mate/core/database/app_database.dart';
import 'package:daily_mate/features/prayer/data/drift_prayer_repository.dart';
import 'package:daily_mate/features/prayer/domain/prayer_calculator.dart';
import 'package:daily_mate/features/prayer/domain/prayer_method.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/domain/prayer_notification_source.dart';
import 'package:daily_mate/features/prayer/domain/prayer_settings.dart';
import 'package:daily_mate/features/reminders/domain/notification_models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftPrayerRepository repo;

  setUp(() {
    db = testDatabase();
    repo = DriftPrayerRepository(db);
  });
  tearDown(() => db.close());

  test('settings start without location, five prayers alerting', () async {
    final settings = await repo.settings();
    expect(settings.hasLocation, isFalse);
    expect(settings.method, PrayerMethod.kemenag);
    for (final prayer in PrayerName.prayers) {
      expect(settings.preference(prayer).notify, isTrue);
    }
    expect(settings.preference(PrayerName.sunrise).notify, isFalse);
  });

  test('location, method and preferences round-trip', () async {
    await repo.setLocation(
      latitude: -7.25,
      longitude: 112.75,
      name: ' Surabaya ',
    );
    await repo.setMethod(PrayerMethod.singapore);
    await repo.setAsrMethod(AsrMethod.hanafi);
    await repo.setPreference(
      PrayerName.maghrib,
      const PrayerPreference(
        adjustmentMinutes: 99,
        advanceMinutes: 10,
        sound: false,
      ),
    );
    final s = await repo.settings();
    expect(s.locationName, 'Surabaya');
    expect(s.method, PrayerMethod.singapore);
    expect(s.asrMethod, AsrMethod.hanafi);
    final maghrib = s.preference(PrayerName.maghrib);
    expect(maghrib.adjustmentMinutes, 60, reason: 'clamped to the CHECK range');
    expect(maghrib.advanceMinutes, 10);
    expect(maghrib.sound, isFalse);
  });

  group('alerts', () {
    final from = DateTime(2026, 10, 14);
    final to = from.add(const Duration(days: 14));

    PrayerNotificationSource source() =>
        PrayerNotificationSource(repo, PrayerCalculator());

    test('none until a location is set', () async {
      expect(await source().alertsBetween(from, to), isEmpty);
    });

    test(
      'five alerts a day for three days, with early alerts and sound',
      () async {
        await repo.setLocation(
          latitude: -6.2088,
          longitude: 106.8456,
          name: 'Jakarta',
        );
        await repo.setPreference(
          PrayerName.fajr,
          const PrayerPreference(advanceMinutes: 10, sound: false),
        );
        await repo.setPreference(
          PrayerName.isha,
          const PrayerPreference(notify: false),
        );

        final alerts = await source().alertsBetween(from, to);
        // 4 prayers + 1 early Subuh alert, per day, for 3 days.
        expect(alerts, hasLength(15));
        expect(alerts.every((a) => a.kind == NotificationKind.prayer), isTrue);
        final fajr = alerts.where((a) => a.title == 'Subuh').toList();
        expect(fajr, hasLength(3));
        expect(fajr.first.sound, isFalse);
        expect(fajr.first.body, startsWith('Time for Subuh · '));
        final early = alerts.where((a) => a.title == 'Subuh in 10 minutes');
        expect(early, hasLength(3));
        expect(
          fajr.first.at.difference(early.first.at),
          const Duration(minutes: 10),
        );
        expect(alerts.any((a) => a.title.startsWith('Isya')), isFalse);
      },
    );
  });
}
