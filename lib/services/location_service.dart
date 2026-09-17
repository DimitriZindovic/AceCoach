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

    try {
      final lastKnown = await Geolocator.getLastKnownPosition();
      final position = lastKnown != null && _isFresh(lastKnown)
          ? lastKnown
          : await Geolocator.getCurrentPosition(locationSettings: _settings);
      return (latitude: position.latitude, longitude: position.longitude);
    } catch (_) {
      throw const AppException('Could not read your location.');
    }
  }

  bool _isFresh(Position position) {
    final age = DateTime.now().difference(position.timestamp);
    return age < const Duration(minutes: 15);
  }
}
