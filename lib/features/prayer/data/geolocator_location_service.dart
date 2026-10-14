import 'package:daily_mate/core/logging/app_logger.dart';
import 'package:daily_mate/features/prayer/domain/location_service.dart';
import 'package:geolocator/geolocator.dart';

/// One coarse position fix on request — never continuous tracking. macOS
/// asks the user the first time.
class GeolocatorLocationService implements LocationService {
  @override
  Future<LocationResult> currentLocation() async {
    LocationResult failed(LocationFailure f) =>
        (latitude: null, longitude: null, failure: f);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return failed(LocationFailure.servicesOff);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return failed(LocationFailure.denied);
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return (
        latitude: position.latitude,
        longitude: position.longitude,
        failure: null,
      );
    } on Exception catch (error, stack) {
      AppLogger.w('Reading the current location failed', error, stack);
      return failed(LocationFailure.unavailable);
    }
  }
}
