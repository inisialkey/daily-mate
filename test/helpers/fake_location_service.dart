import 'package:daily_mate/features/prayer/domain/location_service.dart';

class FakeLocationService implements LocationService {
  LocationResult result = (
    latitude: -6.2,
    longitude: 106.82,
    failure: null,
  );
  int calls = 0;

  @override
  Future<LocationResult> currentLocation() async {
    calls++;
    return result;
  }
}
