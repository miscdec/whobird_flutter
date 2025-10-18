import 'package:geolocator/geolocator.dart';
import 'package:equatable/equatable.dart';

/// A simple entity to hold location data.
class Location extends Equatable {
  final double latitude;
  final double longitude;

  const Location({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

/// Abstract interface for a service that provides device location.
abstract class LocationService {
  Future<Location> getCurrentLocation();
}

/// An implementation of LocationService that uses the `geolocator` package.
class GeolocatorService implements LocationService {
  @override
  Future<Location> getCurrentLocation() async {
    // Note: Permission handling logic (checking for permission, requesting if
    // not granted) should be handled by the repository or use case that calls this.
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return Location(latitude: position.latitude, longitude: position.longitude);
    } catch (e) {
      // Handle location service errors (e.g., service disabled, permissions denied).
      print("Failed to get location: $e");
      // In a real app, this would throw a specific Failure type.
      rethrow;
    }
  }
}