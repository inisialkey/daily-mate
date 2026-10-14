/// Why the current location could not be read.
enum LocationFailure {
  servicesOff('Location Services are turned off in System Settings.'),
  denied('DailyMate is not allowed to use your location.'),
  unavailable("Your location couldn't be determined right now.");

  const LocationFailure(this.message);

  final String message;
}

typedef LocationResult = ({
  double? latitude,
  double? longitude,
  LocationFailure? failure,
});

/// Port to the system's location service. Called only when the user asks.
abstract interface class LocationService {
  Future<LocationResult> currentLocation();
}
