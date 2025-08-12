abstract class DriverPositionRepository {
  Future<void> storePosition({
    required double latitude,
    required double longitude,
  });

  Future<void> storeCurrentPosition();

  Future<bool> startLocationTracking();

  Future<void> stopLocationTracking();

  Future<bool> toggleLocationTracking();

  bool get isLocationTracking;
}