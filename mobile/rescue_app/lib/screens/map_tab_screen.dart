import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:rescue_app/domain/services/api/rest_api_service.dart';

class MapTabScreen extends StatefulWidget {
  const MapTabScreen({super.key});

  @override
  State<MapTabScreen> createState() => _MapTabScreenState();
}

class _MapTabScreenState extends State<MapTabScreen> {
  static const String _mapboxToken =
      String.fromEnvironment('MAPBOX_ACCESS_TOKEN');

  MapboxMap? _mapboxMap;
  StreamSubscription<geo.Position>? _positionSubscription;
  bool _isRequestingPermission = false;
  bool _hasLocationPermission = false;
  bool _isTrackingLocation = false;
  String? _permissionMessage;

  bool get _hasToken => _mapboxToken.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_hasToken) {
      MapboxOptions.setAccessToken(_mapboxToken);
    }
    _initializeLocationFlow();
  }

  @override
  void dispose() {
    _stopLocationTracking();
    super.dispose();
  }

  Future<void> _initializeLocationFlow() async {
    final bool granted = await _requestLocationPermission();
    if (!granted) {
      return;
    }
    await _startLocationTracking();
  }

  Future<bool> _requestLocationPermission() async {
    if (_isRequestingPermission) {
      return _hasLocationPermission;
    }

    _isRequestingPermission = true;
    setState(() {
      _permissionMessage = null;
    });

    final bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _hasLocationPermission = false;
        _permissionMessage =
            'Location service is disabled. Please enable location services.';
      });
      _isRequestingPermission = false;
      return false;
    }

    geo.LocationPermission permission = await geo.Geolocator.checkPermission();

    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
    }

    final bool granted = permission == geo.LocationPermission.always ||
        permission == geo.LocationPermission.whileInUse;

    setState(() {
      _hasLocationPermission = granted;
      if (!granted) {
        _permissionMessage = permission == geo.LocationPermission.deniedForever
            ? 'Location permission is permanently denied. Please enable it from settings.'
            : 'Location permission denied.';
      }
    });

    _isRequestingPermission = false;
    return granted;
  }

  Future<void> _startLocationTracking() async {
    if (_isTrackingLocation) {
      return;
    }

    final geo.LocationSettings settings = geo.LocationSettings(
      accuracy: geo.LocationAccuracy.best,
      distanceFilter: 10,
    );

    _positionSubscription = geo.Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen((geo.Position position) {
      _onLocationChanged(position);
    });

    setState(() {
      _isTrackingLocation = true;
    });

    final geo.Position current = await geo.Geolocator.getCurrentPosition(
      locationSettings: const geo.LocationSettings(
        accuracy: geo.LocationAccuracy.high,
      ),
    );
    _onLocationChanged(current);
  }

  Future<void> _stopLocationTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    if (mounted) {
      setState(() {
        _isTrackingLocation = false;
      });
    }
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
  }

  Future<void> _onLocationChanged(geo.Position position) async {
    _mapboxMap?.setCamera(
      CameraOptions(
        center: Point(
          coordinates: Position(position.longitude, position.latitude),
        ),
        zoom: 14,
      ),
    );
    try {
      await RestApiService(baseUrl: RestApiService.baseUrl)
          .updateCurrentUserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location update failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _retryPermissionsAndTracking() async {
    final bool granted = await _requestLocationPermission();
    if (!granted) {
      return;
    }
    await _startLocationTracking();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasToken) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Mapbox token missing. Run with --dart-define=MAPBOX_ACCESS_TOKEN=your_token',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (!_hasLocationPermission) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _permissionMessage ??
                    'Location permission is required to track your position.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _isRequestingPermission
                    ? null
                    : _retryPermissionsAndTracking,
                child: const Text('Grant Location Permission'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        MapWidget(
          key: const ValueKey('mapWidget'),
          onMapCreated: _onMapCreated,
          cameraOptions: CameraOptions(
            center: Point(
              coordinates: Position(34.7818, 32.0853),
            ),
            zoom: 10.5,
          ),
          styleUri: MapboxStyles.STANDARD,
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: FloatingActionButton.small(
            onPressed: _isTrackingLocation
                ? () async {
                    final geo.Position current =
                        await geo.Geolocator.getCurrentPosition(
                      locationSettings: const geo.LocationSettings(
                        accuracy: geo.LocationAccuracy.high,
                      ),
                    );
                    _onLocationChanged(current);
                  }
                : null,
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}
