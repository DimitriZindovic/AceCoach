import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../constants/api_constants.dart';

/// Why the device position could not be read.
enum LocationErrorKind { serviceDisabled, permissionDenied, timeout, unknown }

/// Raised by [LocationService] instead of the many geolocator exceptions.
class LocationException implements Exception {
  const LocationException(this.kind, [this.cause]);

  final LocationErrorKind kind;
  final Object? cause;

  bool get isPermissionProblem =>
      kind == LocationErrorKind.permissionDenied ||
      kind == LocationErrorKind.serviceDisabled;

  @override
  String toString() => 'LocationException($kind)';
}

/// Reads the device coordinates for the weather lookup.
class LocationService {
  const LocationService();

  /// Low accuracy is plenty for a city-level weather request and is faster.
  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.low,
    timeLimit: ApiConstants.locationTimeout,
  );

  Future<Position> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationErrorKind.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationException(LocationErrorKind.permissionDenied);
    }

    try {
      // A recent cached fix avoids waking the GPS chip at all.
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null && _isFresh(lastKnown)) return lastKnown;
      return await Geolocator.getCurrentPosition(locationSettings: _settings);
    } on TimeoutException catch (error) {
      throw LocationException(LocationErrorKind.timeout, error);
    } on LocationServiceDisabledException catch (error) {
      throw LocationException(LocationErrorKind.serviceDisabled, error);
    } on PermissionDeniedException catch (error) {
      throw LocationException(LocationErrorKind.permissionDenied, error);
    } catch (error) {
      throw LocationException(LocationErrorKind.unknown, error);
    }
  }

  bool _isFresh(Position position) {
    final age = DateTime.now().difference(position.timestamp);
    return age < const Duration(minutes: 15);
  }
}
