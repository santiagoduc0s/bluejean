import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:lune/data/services/permission_service.dart';
import 'package:lune/domain/enums/enums.dart';

class LocationTrackingService {
  LocationTrackingService({required PermissionService permissionService})
    : _permissionService = permissionService;

  final PermissionService _permissionService;

  StreamController<Position>? _positionStreamController;
  StreamSubscription<Position>? _locationSubscription;

  bool _isTracking = false;

  Stream<Position> get positionStream {
    _positionStreamController ??= StreamController<Position>.broadcast();
    return _positionStreamController!.stream;
  }

  bool get isTracking => _isTracking;

  Future<bool> startTracking({
    String? notificationTitle,
    String? notificationText,
  }) async {
    if (_isTracking) {
      return true;
    }

    // Request regular location permission (required)
    final permissionStatus = await _permissionService.status(
      PermissionType.location,
    );

    if (permissionStatus != PermissionStatus.granted) {
      final requestResult = await _permissionService.request(
        PermissionType.location,
      );

      if (requestResult != PermissionStatus.granted) {
        await _permissionService.openSettings();
        return false;
      }
    }

    // Request background location permission (optional - continue if denied)
    try {
      final backgroundStatus = await _permissionService.status(
        PermissionType.locationAlways,
      );

      if (backgroundStatus != PermissionStatus.granted) {
        await _permissionService.request(PermissionType.locationAlways);
        // Continue regardless of result - background permission is nice to have
      }
    } catch (e) {
      // Background permission request failed, but continue anyway
      // This is expected on some devices/OS versions
    }

    try {
      _positionStreamController ??= StreamController<Position>.broadcast();

      late LocationSettings locationSettings;

      if (Platform.isAndroid) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          // ignore: avoid_redundant_argument_values
          distanceFilter: 0,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationText:
                notificationText ??
                'Bus Escolares is tracking the bus location',
            notificationTitle: notificationTitle ?? 'Tracking Location',
            enableWakeLock: true,
          ),
        );
      } else if (Platform.isIOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.automotiveNavigation,
          // ignore: avoid_redundant_argument_values
          distanceFilter: 0,
          showBackgroundLocationIndicator: true,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          // ignore: avoid_redundant_argument_values
          distanceFilter: 0,
        );
      }

      _locationSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        _positionStreamController?.add(position);
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

    await _locationSubscription?.cancel();
    _locationSubscription = null;
    _isTracking = false;
  }

  Future<Position> getCurrentLocation() async {
    final permissionStatus = await _permissionService.status(
      PermissionType.location,
    );
    if (permissionStatus != PermissionStatus.granted) {
      final requestResult = await _permissionService.request(
        PermissionType.location,
      );
      if (requestResult != PermissionStatus.granted) {
        throw Exception('Location permission denied');
      }
    }

    if (_isTracking) {
      final completer = Completer<Position>();
      late StreamSubscription<Position> subscription;

      subscription = positionStream.listen((position) {
        if (!completer.isCompleted) {
          completer.complete(position);
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
      late LocationSettings locationSettings;

      if (Platform.isAndroid) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          forceLocationManager: true,
        );
      } else if (Platform.isIOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.automotiveNavigation,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
        );
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
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
  }
}
