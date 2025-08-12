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
    this.thresholdMeters,
  });

  final double? initialLatitude;
  final double? initialLongitude;
  final int? thresholdMeters;

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late double _currentLatitude;
  late double _currentLongitude;
  Set<Circle> _circles = {};
  late int _selectedThreshold;

  // Default location (Uruguay - Montevideo area)
  static const double _defaultLatitude = -34.9033;
  static const double _defaultLongitude = -56.1882;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _currentLatitude = widget.initialLatitude ?? _defaultLatitude;
    _currentLongitude = widget.initialLongitude ?? _defaultLongitude;
    _selectedThreshold = widget.thresholdMeters ?? 200;

    // Update circles after the widget is fully rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCircles();
    });
  }

  void _updateCircles() {
    if (mounted) {
      setState(() {
        _circles = {
          Circle(
            circleId: const CircleId('threshold'),
            center: LatLng(_currentLatitude, _currentLongitude),
            radius: _selectedThreshold.toDouble(),
            fillColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            strokeColor: Theme.of(context).colorScheme.primary,
            strokeWidth: 2,
          ),
        };
      });
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentLatitude = position.target.latitude;
      _currentLongitude = position.target.longitude;
      _updateCircles();
    });
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
      _updateCircles();
    });
  }

  void _onDonePressed() {
    context.pop({
      'latitude': _currentLatitude,
      'longitude': _currentLongitude,
      'thresholdMeters': _selectedThreshold,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectLocation),
        actions: [
          TextButton(
            onPressed: _onDonePressed,
            child: Text(l10n.done),
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
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
            circles: _circles,
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
            top: 80,
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
              child: DropdownButtonFormField<int>(
                value: _selectedThreshold,
                decoration: const InputDecoration(
                  labelText: 'Notification Distance',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  for (int meters in [100, 200, 300, 400, 500, 600, 700])
                    DropdownMenuItem(
                      value: meters,
                      child: Text('${meters}m'),
                    ),
                ],
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedThreshold = newValue;
                      _updateCircles();
                    });
                  }
                },
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lat: ${_currentLatitude.toStringAsFixed(6)}, '
                    'Lng: ${_currentLongitude.toStringAsFixed(6)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Notification distance: ${_selectedThreshold}m',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
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
