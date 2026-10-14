import 'package:daily_mate/features/prayer/domain/city_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('search matches names first, then countries', () {
    expect(CityCatalog.search('jak').first.name, 'Jakarta');
    expect(CityCatalog.search('MAKKAH').single.country, 'Saudi Arabia');
    final malaysia = CityCatalog.search('malaysia');
    expect(malaysia.map((c) => c.country).toSet(), {'Malaysia'});
  });

  test('nearest names a GPS fix, but not one far from any city', () {
    expect(CityCatalog.nearest(-6.25, 106.80)?.name, 'Jakarta');
    expect(CityCatalog.nearest(-30, 80), isNull);
  });

  test('distance is roughly right (Jakarta–Bandung ≈ 120 km)', () {
    expect(
      CityCatalog.distanceKm(-6.2088, 106.8456, -6.9175, 107.6191),
      inInclusiveRange(110, 130),
    );
  });

  test('every city has valid coordinates', () {
    for (final city in CityCatalog.cities) {
      expect(city.latitude.abs(), lessThanOrEqualTo(90), reason: city.name);
      expect(city.longitude.abs(), lessThanOrEqualTo(180), reason: city.name);
    }
  });
}
