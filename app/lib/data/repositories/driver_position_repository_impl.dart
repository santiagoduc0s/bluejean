import 'dart:async';
import 'package:background_location/background_location.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/data/services/location_tracking_service.dart';
import 'package:lune/domain/repositories/driver_position_repository.dart';

class DriverPositionRepositoryImpl implements DriverPositionRepository {
  DriverPositionRepositoryImpl({
    required ApiClient apiClient,
    required LocationTrackingService locationTrackingService,
  })  : _apiClient = apiClient,
        _locationTrackingService = locationTrackingService;
  final ApiClient _apiClient;
  final LocationTrackingService _locationTrackingService;

  StreamSubscription<Location>? _positionSubscription;
  DateTime? _lastSentTime;

  @override
  Future<void> storePosition({
    required double latitude,
    required double longitude,
  }) async {
    await _apiClient.post(
      '/api/v1/driver-positions',
      body: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }

  @override
  Future<void> storeCurrentPosition() async {
    final position = await _locationTrackingService.getCurrentLocation();
    await storePosition(
      latitude: position.latitude!,
      longitude: position.longitude!,
    );
  }

  @override
  Future<bool> startLocationTracking() async {
    final started = await _locationTrackingService.startTracking();

    if (started) {
      // Listen to position updates and send to API
      _positionSubscription = _locationTrackingService.positionStream.listen(
        (Location position) async {
          try {
            // Check if we should send this position (throttle to max 1 per 10 seconds)
            final now = DateTime.now();
            if (_lastSentTime == null || 
                now.difference(_lastSentTime!).inSeconds >= 10) {
              await storePosition(
                latitude: position.latitude!,
                longitude: position.longitude!,
              );
              _lastSentTime = now;
            }
          } catch (e) {
            // Handle API errors but continue tracking
            // Don't update _lastSentTime on failure so we can retry sooner
          }
        },
      );
    }

    return started;
  }

  @override
  Future<void> stopLocationTracking() async {
    await _locationTrackingService.stopTracking();
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _lastSentTime = null;
  }

  @override
  Future<bool> toggleLocationTracking() async {
    if (isLocationTracking) {
      await stopLocationTracking();
      return false;
    } else {
      return await startLocationTracking();
    }
  }

  @override
  bool get isLocationTracking => _locationTrackingService.isTracking;
}
