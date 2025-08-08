import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/l10n/l10n.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late double _currentLatitude;
  late double _currentLongitude;

  // Default location (you can change this to your preferred default)
  static const double _defaultLatitude = 37.7749;
  static const double _defaultLongitude = -122.4194;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _currentLatitude = widget.initialLatitude ?? _defaultLatitude;
    _currentLongitude = widget.initialLongitude ?? _defaultLongitude;
  }

  Future<void> _onCameraIdle() async {
    final controller = await _mapController.future;
    final visibleRegion = await controller.getVisibleRegion();

    final centerLat =
        (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) /
            2;
    final centerLng = (visibleRegion.northeast.longitude +
            visibleRegion.southwest.longitude) /
        2;

    setState(() {
      _currentLatitude = centerLat;
      _currentLongitude = centerLng;
    });
  }

  void _onDonePressed() {
    context.pop({
      'latitude': _currentLatitude,
      'longitude': _currentLongitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectLocation),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        actions: [
          TextButton(
            onPressed: _onDonePressed,
            child: Text(
              l10n.done,
              style: TextStyle(
                color: colors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_currentLatitude, _currentLongitude),
              zoom: 15,
            ),
            onMapCreated: _mapController.complete,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
          ),
          Center(
            child: Icon(
              Icons.add,
              size: 40,
              color: colors.primary,
              shadows: [
                const Shadow(
                  color: Colors.white,
                  blurRadius: 4,
                ),
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                l10n.dragMapToSelectLocation,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Lat: ${_currentLatitude.toStringAsFixed(6)}, '
                'Lng: ${_currentLongitude.toStringAsFixed(6)}',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationResult {
  const LocationResult({
    required this.latitude,
    required this.longitude,
  });

  factory LocationResult.fromMap(Map<String, dynamic> map) {
    return LocationResult(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  final double latitude;
  final double longitude;
}
