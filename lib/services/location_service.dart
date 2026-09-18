import 'package:geolocator/geolocator.dart';

import '../constants/api_constants.dart';
import '../models/app_exception.dart';

class LocationService {
  const LocationService();

  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.low,
    timeLimit: ApiConstants.locationTimeout,
  );

  Future<({double latitude, double longitude})> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const AppException('Location is turned off on this device.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const AppException('Location access was denied.');
    }

    Position? lastKnown;
    try {
      lastKnown = await Geolocator.getLastKnownPosition();
    } on Object catch (_) {
      lastKnown = null;
    }
    if (lastKnown != null && _isFresh(lastKnown)) {
      return (latitude: lastKnown.latitude, longitude: lastKnown.longitude);
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: _settings,
      );
      return (latitude: position.latitude, longitude: position.longitude);
    } on Object catch (_) {
      if (lastKnown != null) {
        return (latitude: lastKnown.latitude, longitude: lastKnown.longitude);
      }
      throw const AppException('Could not read your location.');
    }
  }

  bool _isFresh(Position position) {
    final age = DateTime.now().difference(position.timestamp);
    return age < const Duration(minutes: 15);
  }
}
