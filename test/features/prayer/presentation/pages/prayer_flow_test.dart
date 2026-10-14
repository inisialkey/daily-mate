import 'package:daily_mate/core/di/service_locator.dart';
import 'package:daily_mate/features/prayer/domain/location_service.dart';
import 'package:daily_mate/features/prayer/domain/prayer_name.dart';
import 'package:daily_mate/features/prayer/domain/prayer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_location_service.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  PrayerRepository repo() => sl<PrayerRepository>();

  Future<void> openPrayer(WidgetTester tester) async {
    await tester.tap(find.text('Prayer Times').first);
    await tester.pumpAndSettle();
  }

  testWidgets('choosing a city shows the schedule and next prayer', (
    tester,
  ) async {
    await pumpApp(tester);
    await openPrayer(tester);
    expect(find.text('Set your location for prayer times'), findsOneWidget);

    await tester.tap(find.text('Choose City'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Search cities'),
      'jakarta',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jakarta'));
    await tester.pumpAndSettle();
    await settleAsync(tester);

    expect(find.text('Next prayer'), findsOneWidget);
    for (final name in PrayerName.values) {
      expect(find.text(name.label), findsWidgets);
    }
    expect((await tester.runAsync(repo().settings))!.locationName, 'Jakarta');
  });

  testWidgets('current location is named after the nearest city', (
    tester,
  ) async {
    final location = FakeLocationService();
    await pumpApp(tester, location: location);
    await openPrayer(tester);
    await tester.tap(find.text('Use Current Location'));
    await tester.pumpAndSettle();
    await settleAsync(tester);

    expect(location.calls, 1);
    expect(
      (await tester.runAsync(repo().settings))!.locationName,
      'Near Jakarta',
    );
  });

  testWidgets('a location failure is explained, nothing is saved', (
    tester,
  ) async {
    final location = FakeLocationService()
      ..result = (
        latitude: null,
        longitude: null,
        failure: LocationFailure.denied,
      );
    await pumpApp(tester, location: location);
    await openPrayer(tester);
    await tester.tap(find.text('Use Current Location'));
    await tester.pumpAndSettle();

    expect(find.text(LocationFailure.denied.message), findsOneWidget);
    expect((await tester.runAsync(repo().settings))!.hasLocation, isFalse);
  });

  testWidgets('the bell turns a prayer alert off', (tester) async {
    await pumpApp(tester);
    await tester.runAsync(
      () => repo().setLocation(
        latitude: -6.2088,
        longitude: 106.8456,
        name: 'Jakarta',
      ),
    );
    await openPrayer(tester);

    await tester.tap(find.byTooltip('Turn off Subuh alert'));
    await tester.pumpAndSettle();
    await settleAsync(tester);
    final settings = await tester.runAsync(repo().settings);
    expect(settings!.preference(PrayerName.fajr).notify, isFalse);
    expect(find.byTooltip('Alert me at Subuh'), findsOneWidget);
  });
}
