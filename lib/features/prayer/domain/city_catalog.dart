import 'dart:math' as math;

typedef City = ({
  String name,
  String country,
  double latitude,
  double longitude,
});

/// Offline city list for choosing a prayer location without typing
/// coordinates: every Indonesian provincial capital plus major cities, and
/// large cities worldwide. Coordinates are city centres (±0.01°, well under
/// a minute of prayer time).
abstract final class CityCatalog {
  static const List<City> cities = [
    // Indonesia
    (
      name: 'Banda Aceh',
      country: 'Indonesia',
      latitude: 5.5483,
      longitude: 95.3238,
    ),
    (
      name: 'Lhokseumawe',
      country: 'Indonesia',
      latitude: 5.1801,
      longitude: 97.1507,
    ),
    (name: 'Medan', country: 'Indonesia', latitude: 3.5952, longitude: 98.6722),
    (
      name: 'Pematangsiantar',
      country: 'Indonesia',
      latitude: 2.9595,
      longitude: 99.0687,
    ),
    (
      name: 'Padang',
      country: 'Indonesia',
      latitude: -0.9471,
      longitude: 100.4172,
    ),
    (
      name: 'Bukittinggi',
      country: 'Indonesia',
      latitude: -0.3056,
      longitude: 100.3692,
    ),
    (
      name: 'Pekanbaru',
      country: 'Indonesia',
      latitude: 0.5071,
      longitude: 101.4478,
    ),
    (
      name: 'Dumai',
      country: 'Indonesia',
      latitude: 1.6658,
      longitude: 101.4473,
    ),
    (
      name: 'Batam',
      country: 'Indonesia',
      latitude: 1.0456,
      longitude: 104.0305,
    ),
    (
      name: 'Tanjung Pinang',
      country: 'Indonesia',
      latitude: 0.9188,
      longitude: 104.4554,
    ),
    (
      name: 'Jambi',
      country: 'Indonesia',
      latitude: -1.6101,
      longitude: 103.6131,
    ),
    (
      name: 'Palembang',
      country: 'Indonesia',
      latitude: -2.9761,
      longitude: 104.7754,
    ),
    (
      name: 'Pangkalpinang',
      country: 'Indonesia',
      latitude: -2.1316,
      longitude: 106.1169,
    ),
    (
      name: 'Bengkulu',
      country: 'Indonesia',
      latitude: -3.7928,
      longitude: 102.2608,
    ),
    (
      name: 'Bandar Lampung',
      country: 'Indonesia',
      latitude: -5.3971,
      longitude: 105.2668,
    ),
    (
      name: 'Jakarta',
      country: 'Indonesia',
      latitude: -6.2088,
      longitude: 106.8456,
    ),
    (
      name: 'Bogor',
      country: 'Indonesia',
      latitude: -6.5971,
      longitude: 106.8060,
    ),
    (
      name: 'Depok',
      country: 'Indonesia',
      latitude: -6.4025,
      longitude: 106.7942,
    ),
    (
      name: 'Tangerang',
      country: 'Indonesia',
      latitude: -6.1783,
      longitude: 106.6319,
    ),
    (
      name: 'Tangerang Selatan',
      country: 'Indonesia',
      latitude: -6.2886,
      longitude: 106.7179,
    ),
    (
      name: 'Bekasi',
      country: 'Indonesia',
      latitude: -6.2383,
      longitude: 106.9756,
    ),
    (
      name: 'Serang',
      country: 'Indonesia',
      latitude: -6.1200,
      longitude: 106.1503,
    ),
    (
      name: 'Cilegon',
      country: 'Indonesia',
      latitude: -6.0025,
      longitude: 106.0111,
    ),
    (
      name: 'Bandung',
      country: 'Indonesia',
      latitude: -6.9175,
      longitude: 107.6191,
    ),
    (
      name: 'Cimahi',
      country: 'Indonesia',
      latitude: -6.8722,
      longitude: 107.5425,
    ),
    (
      name: 'Sukabumi',
      country: 'Indonesia',
      latitude: -6.9277,
      longitude: 106.9300,
    ),
    (
      name: 'Cirebon',
      country: 'Indonesia',
      latitude: -6.7320,
      longitude: 108.5523,
    ),
    (
      name: 'Tasikmalaya',
      country: 'Indonesia',
      latitude: -7.3274,
      longitude: 108.2207,
    ),
    (
      name: 'Karawang',
      country: 'Indonesia',
      latitude: -6.3227,
      longitude: 107.3376,
    ),
    (
      name: 'Semarang',
      country: 'Indonesia',
      latitude: -6.9667,
      longitude: 110.4167,
    ),
    (
      name: 'Surakarta (Solo)',
      country: 'Indonesia',
      latitude: -7.5755,
      longitude: 110.8243,
    ),
    (
      name: 'Yogyakarta',
      country: 'Indonesia',
      latitude: -7.7956,
      longitude: 110.3695,
    ),
    (
      name: 'Magelang',
      country: 'Indonesia',
      latitude: -7.4797,
      longitude: 110.2177,
    ),
    (
      name: 'Purwokerto',
      country: 'Indonesia',
      latitude: -7.4245,
      longitude: 109.2302,
    ),
    (
      name: 'Tegal',
      country: 'Indonesia',
      latitude: -6.8694,
      longitude: 109.1402,
    ),
    (
      name: 'Pekalongan',
      country: 'Indonesia',
      latitude: -6.8886,
      longitude: 109.6753,
    ),
    (
      name: 'Kudus',
      country: 'Indonesia',
      latitude: -6.8048,
      longitude: 110.8405,
    ),
    (
      name: 'Surabaya',
      country: 'Indonesia',
      latitude: -7.2575,
      longitude: 112.7521,
    ),
    (
      name: 'Sidoarjo',
      country: 'Indonesia',
      latitude: -7.4478,
      longitude: 112.7183,
    ),
    (
      name: 'Malang',
      country: 'Indonesia',
      latitude: -7.9666,
      longitude: 112.6326,
    ),
    (
      name: 'Kediri',
      country: 'Indonesia',
      latitude: -7.8480,
      longitude: 112.0178,
    ),
    (
      name: 'Madiun',
      country: 'Indonesia',
      latitude: -7.6298,
      longitude: 111.5239,
    ),
    (
      name: 'Jember',
      country: 'Indonesia',
      latitude: -8.1845,
      longitude: 113.6681,
    ),
    (
      name: 'Banyuwangi',
      country: 'Indonesia',
      latitude: -8.2192,
      longitude: 114.3691,
    ),
    (
      name: 'Denpasar',
      country: 'Indonesia',
      latitude: -8.6705,
      longitude: 115.2126,
    ),
    (
      name: 'Mataram',
      country: 'Indonesia',
      latitude: -8.5833,
      longitude: 116.1167,
    ),
    (
      name: 'Bima',
      country: 'Indonesia',
      latitude: -8.4605,
      longitude: 118.7270,
    ),
    (
      name: 'Kupang',
      country: 'Indonesia',
      latitude: -10.1772,
      longitude: 123.6070,
    ),
    (
      name: 'Pontianak',
      country: 'Indonesia',
      latitude: -0.0263,
      longitude: 109.3425,
    ),
    (
      name: 'Singkawang',
      country: 'Indonesia',
      latitude: 0.9067,
      longitude: 108.9850,
    ),
    (
      name: 'Palangka Raya',
      country: 'Indonesia',
      latitude: -2.2161,
      longitude: 113.9135,
    ),
    (
      name: 'Banjarmasin',
      country: 'Indonesia',
      latitude: -3.3186,
      longitude: 114.5944,
    ),
    (
      name: 'Banjarbaru',
      country: 'Indonesia',
      latitude: -3.4572,
      longitude: 114.8103,
    ),
    (
      name: 'Samarinda',
      country: 'Indonesia',
      latitude: -0.5022,
      longitude: 117.1536,
    ),
    (
      name: 'Balikpapan',
      country: 'Indonesia',
      latitude: -1.2379,
      longitude: 116.8529,
    ),
    (
      name: 'Tanjung Selor',
      country: 'Indonesia',
      latitude: 2.8375,
      longitude: 117.3653,
    ),
    (
      name: 'Tarakan',
      country: 'Indonesia',
      latitude: 3.3000,
      longitude: 117.6333,
    ),
    (
      name: 'Manado',
      country: 'Indonesia',
      latitude: 1.4748,
      longitude: 124.8421,
    ),
    (
      name: 'Gorontalo',
      country: 'Indonesia',
      latitude: 0.5435,
      longitude: 123.0568,
    ),
    (
      name: 'Palu',
      country: 'Indonesia',
      latitude: -0.8917,
      longitude: 119.8707,
    ),
    (
      name: 'Mamuju',
      country: 'Indonesia',
      latitude: -2.6748,
      longitude: 118.8885,
    ),
    (
      name: 'Makassar',
      country: 'Indonesia',
      latitude: -5.1477,
      longitude: 119.4327,
    ),
    (
      name: 'Parepare',
      country: 'Indonesia',
      latitude: -4.0135,
      longitude: 119.6255,
    ),
    (
      name: 'Kendari',
      country: 'Indonesia',
      latitude: -3.9985,
      longitude: 122.5129,
    ),
    (
      name: 'Ambon',
      country: 'Indonesia',
      latitude: -3.6954,
      longitude: 128.1814,
    ),
    (
      name: 'Ternate',
      country: 'Indonesia',
      latitude: 0.7893,
      longitude: 127.3842,
    ),
    (
      name: 'Sofifi',
      country: 'Indonesia',
      latitude: 0.7376,
      longitude: 127.5588,
    ),
    (
      name: 'Jayapura',
      country: 'Indonesia',
      latitude: -2.5916,
      longitude: 140.6690,
    ),
    (
      name: 'Manokwari',
      country: 'Indonesia',
      latitude: -0.8615,
      longitude: 134.0620,
    ),
    (
      name: 'Sorong',
      country: 'Indonesia',
      latitude: -0.8762,
      longitude: 131.2558,
    ),
    (
      name: 'Merauke',
      country: 'Indonesia',
      latitude: -8.4932,
      longitude: 140.4018,
    ),
    (
      name: 'Nabire',
      country: 'Indonesia',
      latitude: -3.3667,
      longitude: 135.4833,
    ),
    (
      name: 'Timika',
      country: 'Indonesia',
      latitude: -4.5468,
      longitude: 136.8883,
    ),
    // Worldwide
    (
      name: 'Makkah',
      country: 'Saudi Arabia',
      latitude: 21.4225,
      longitude: 39.8262,
    ),
    (
      name: 'Madinah',
      country: 'Saudi Arabia',
      latitude: 24.4672,
      longitude: 39.6111,
    ),
    (
      name: 'Jeddah',
      country: 'Saudi Arabia',
      latitude: 21.4858,
      longitude: 39.1925,
    ),
    (
      name: 'Riyadh',
      country: 'Saudi Arabia',
      latitude: 24.7136,
      longitude: 46.6753,
    ),
    (
      name: 'Dubai',
      country: 'United Arab Emirates',
      latitude: 25.2048,
      longitude: 55.2708,
    ),
    (
      name: 'Abu Dhabi',
      country: 'United Arab Emirates',
      latitude: 24.4539,
      longitude: 54.3773,
    ),
    (name: 'Doha', country: 'Qatar', latitude: 25.2854, longitude: 51.5310),
    (
      name: 'Kuwait City',
      country: 'Kuwait',
      latitude: 29.3759,
      longitude: 47.9774,
    ),
    (name: 'Manama', country: 'Bahrain', latitude: 26.2285, longitude: 50.5860),
    (name: 'Muscat', country: 'Oman', latitude: 23.5880, longitude: 58.3829),
    (name: 'Amman', country: 'Jordan', latitude: 31.9454, longitude: 35.9284),
    (
      name: 'Jerusalem',
      country: 'Palestine',
      latitude: 31.7683,
      longitude: 35.2137,
    ),
    (name: 'Baghdad', country: 'Iraq', latitude: 33.3152, longitude: 44.3661),
    (name: 'Tehran', country: 'Iran', latitude: 35.6892, longitude: 51.3890),
    (
      name: 'Istanbul',
      country: 'Türkiye',
      latitude: 41.0082,
      longitude: 28.9784,
    ),
    (name: 'Ankara', country: 'Türkiye', latitude: 39.9334, longitude: 32.8597),
    (name: 'Cairo', country: 'Egypt', latitude: 30.0444, longitude: 31.2357),
    (name: 'Khartoum', country: 'Sudan', latitude: 15.5007, longitude: 32.5599),
    (
      name: 'Casablanca',
      country: 'Morocco',
      latitude: 33.5731,
      longitude: -7.5898,
    ),
    (name: 'Algiers', country: 'Algeria', latitude: 36.7538, longitude: 3.0588),
    (name: 'Tunis', country: 'Tunisia', latitude: 36.8065, longitude: 10.1815),
    (name: 'Lagos', country: 'Nigeria', latitude: 6.5244, longitude: 3.3792),
    (name: 'Nairobi', country: 'Kenya', latitude: -1.2921, longitude: 36.8219),
    (
      name: 'Johannesburg',
      country: 'South Africa',
      latitude: -26.2041,
      longitude: 28.0473,
    ),
    (
      name: 'Karachi',
      country: 'Pakistan',
      latitude: 24.8607,
      longitude: 67.0011,
    ),
    (
      name: 'Lahore',
      country: 'Pakistan',
      latitude: 31.5204,
      longitude: 74.3587,
    ),
    (
      name: 'Islamabad',
      country: 'Pakistan',
      latitude: 33.6844,
      longitude: 73.0479,
    ),
    (
      name: 'New Delhi',
      country: 'India',
      latitude: 28.6139,
      longitude: 77.2090,
    ),
    (name: 'Mumbai', country: 'India', latitude: 19.0760, longitude: 72.8777),
    (
      name: 'Dhaka',
      country: 'Bangladesh',
      latitude: 23.8103,
      longitude: 90.4125,
    ),
    (
      name: 'Kuala Lumpur',
      country: 'Malaysia',
      latitude: 3.1390,
      longitude: 101.6869,
    ),
    (
      name: 'Johor Bahru',
      country: 'Malaysia',
      latitude: 1.4927,
      longitude: 103.7414,
    ),
    (
      name: 'Kota Kinabalu',
      country: 'Malaysia',
      latitude: 5.9804,
      longitude: 116.0735,
    ),
    (
      name: 'Singapore',
      country: 'Singapore',
      latitude: 1.3521,
      longitude: 103.8198,
    ),
    (
      name: 'Bandar Seri Begawan',
      country: 'Brunei',
      latitude: 4.9031,
      longitude: 114.9398,
    ),
    (
      name: 'Bangkok',
      country: 'Thailand',
      latitude: 13.7563,
      longitude: 100.5018,
    ),
    (
      name: 'Manila',
      country: 'Philippines',
      latitude: 14.5995,
      longitude: 120.9842,
    ),
    (name: 'Tokyo', country: 'Japan', latitude: 35.6762, longitude: 139.6503),
    (
      name: 'Seoul',
      country: 'South Korea',
      latitude: 37.5665,
      longitude: 126.9780,
    ),
    (name: 'Beijing', country: 'China', latitude: 39.9042, longitude: 116.4074),
    (
      name: 'Hong Kong',
      country: 'China',
      latitude: 22.3193,
      longitude: 114.1694,
    ),
    (
      name: 'Sydney',
      country: 'Australia',
      latitude: -33.8688,
      longitude: 151.2093,
    ),
    (
      name: 'Melbourne',
      country: 'Australia',
      latitude: -37.8136,
      longitude: 144.9631,
    ),
    (
      name: 'Perth',
      country: 'Australia',
      latitude: -31.9505,
      longitude: 115.8605,
    ),
    (
      name: 'London',
      country: 'United Kingdom',
      latitude: 51.5072,
      longitude: -0.1276,
    ),
    (name: 'Paris', country: 'France', latitude: 48.8566, longitude: 2.3522),
    (
      name: 'Amsterdam',
      country: 'Netherlands',
      latitude: 52.3676,
      longitude: 4.9041,
    ),
    (name: 'Berlin', country: 'Germany', latitude: 52.5200, longitude: 13.4050),
    (name: 'Moscow', country: 'Russia', latitude: 55.7558, longitude: 37.6173),
    (
      name: 'New York',
      country: 'United States',
      latitude: 40.7128,
      longitude: -74.0060,
    ),
    (
      name: 'Washington, D.C.',
      country: 'United States',
      latitude: 38.9072,
      longitude: -77.0369,
    ),
    (
      name: 'Los Angeles',
      country: 'United States',
      latitude: 34.0522,
      longitude: -118.2437,
    ),
    (
      name: 'Toronto',
      country: 'Canada',
      latitude: 43.6532,
      longitude: -79.3832,
    ),
  ];

  /// Cities whose name or country contains [query], name matches first.
  static List<City> search(String query, {int limit = 30}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return cities.take(limit).toList();
    bool nameHas(City c) => c.name.toLowerCase().contains(q);
    return [
      ...cities.where(nameHas),
      ...cities.where(
        (c) => !nameHas(c) && c.country.toLowerCase().contains(q),
      ),
    ].take(limit).toList();
  }

  /// The closest listed city within [maxKm], for naming a GPS fix.
  static City? nearest(double latitude, double longitude, {double maxKm = 60}) {
    City? best;
    var bestKm = double.infinity;
    for (final city in cities) {
      final km = distanceKm(latitude, longitude, city.latitude, city.longitude);
      if (km < bestKm) {
        bestKm = km;
        best = city;
      }
    }
    return bestKm <= maxKm ? best : null;
  }

  /// Great-circle distance (haversine).
  static double distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const earthKm = 6371.0;
    double rad(double deg) => deg * math.pi / 180;
    final dLat = rad(lat2 - lat1);
    final dLon = rad(lon2 - lon1);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(lat1)) *
            math.cos(rad(lat2)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * earthKm * math.asin(math.sqrt(a));
  }
}
