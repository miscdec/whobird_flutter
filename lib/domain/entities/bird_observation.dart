import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class BirdObservation extends Equatable {
  final String id;
  final String commonName;
  final String scientificName;
  final double latitude;
  final double longitude;
  final double confidence;
  final DateTime timestamp;

  const BirdObservation({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.latitude,
    required this.longitude,
    required this.confidence,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        commonName,
        scientificName,
        latitude,
        longitude,
        confidence,
        timestamp,
      ];
}