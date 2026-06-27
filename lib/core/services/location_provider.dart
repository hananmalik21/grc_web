import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'location_service.dart';

final locationProvider = AsyncNotifierProvider<LocationNotifier, LocationData?>(LocationNotifier.new);

class LocationNotifier extends AsyncNotifier<LocationData?> {
  @override
  Future<LocationData?> build() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return null;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: const Duration(seconds: 10)),
      );
      return LocationData(latitude: position.latitude, longitude: position.longitude);
    } catch (e, st) {
      debugPrint('LocationProvider: Failed to get position: $e\n$st');
      return null;
    }
  }

  /// Re-fetches location when user may have moved.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
