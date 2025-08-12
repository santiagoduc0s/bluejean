import 'dart:async';
import 'package:background_location/background_location.dart';
import 'package:lune/data/services/permission_service.dart';
import 'package:lune/domain/enums/enums.dart';

class LocationTrackingService {
  LocationTrackingService({
    required PermissionService permissionService,
  }) : _permissionService = permissionService;

  final PermissionService _permissionService;

  StreamController<Location>? _positionStreamController;
  StreamSubscription<Location>? _locationSubscription;

  bool _isTracking = false;

  Stream<Location> get positionStream {
    _positionStreamController ??= StreamController<Location>.broadcast();
    return _positionStreamController!.stream;
  }

  bool get isTracking => _isTracking;

  Future<bool> startTracking() async {
    if (_isTracking) {
      return true;
    }

    final permissionStatus =
        await _permissionService.status(PermissionType.location);
    if (permissionStatus != PermissionStatus.granted) {
      final requestResult =
          await _permissionService.request(PermissionType.location);

      if (requestResult != PermissionStatus.granted) {
        await _permissionService.openSettings();
        return false;
      }
    }

    try {
      _positionStreamController ??= StreamController<Location>.broadcast();

      await BackgroundLocation.setAndroidNotification(
        title: 'Location Tracking',
        message: 'Tracking driver position in background',
        icon: '@mipmap/ic_launcher',
      );

      await BackgroundLocation.setAndroidConfiguration(10000);

      await BackgroundLocation.startLocationService(
        distanceFilter: 10,
      );

      BackgroundLocation.getLocationUpdates((location) {
        _positionStreamController?.add(location);
      });

      _isTracking = true;
      return true;
    } catch (e) {
      _isTracking = false;
      throw Exception('Failed to start location tracking: $e');
    }
  }

  Future<void> stopTracking() async {
    if (!_isTracking) {
      return;
    }

    await BackgroundLocation.stopLocationService();
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    _isTracking = false;
  }

  Future<Location> getCurrentLocation() async {
    final permissionStatus =
        await _permissionService.status(PermissionType.location);
    if (permissionStatus != PermissionStatus.granted) {
      final requestResult =
          await _permissionService.request(PermissionType.location);
      if (requestResult != PermissionStatus.granted) {
        throw Exception('Location permission denied');
      }
    }

    if (_isTracking) {
      final completer = Completer<Location>();
      late StreamSubscription<Location> subscription;

      subscription = positionStream.listen((location) {
        if (!completer.isCompleted) {
          completer.complete(location);
          subscription.cancel();
        }
      });

      return completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          subscription.cancel();
          throw Exception('Location request timeout while tracking');
        },
      );
    }

    try {
      final completer = Completer<Location>();

      BackgroundLocation.getLocationUpdates((location) {
        if (!completer.isCompleted) {
          completer.complete(location);
        }
      });

      await BackgroundLocation.startLocationService();

      final location = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Location request timeout'),
      );

      await BackgroundLocation.stopLocationService();

      return location;
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  Future<bool> toggleTracking() async {
    if (_isTracking) {
      await stopTracking();
      return false;
    } else {
      return startTracking();
    }
  }

  void dispose() {
    _locationSubscription?.cancel();
    _positionStreamController?.close();
    BackgroundLocation.stopLocationService();
  }
}
