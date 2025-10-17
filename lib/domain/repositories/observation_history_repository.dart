import 'package:whobird_flutter/domain/entities/bird_observation.dart';

/// The contract for managing the local storage of bird observations.
///
/// The implementation of this contract will be in the Data layer.
abstract class ObservationHistoryRepository {
  /// Saves a [BirdObservation] to local storage.
  Future<void> saveObservation(BirdObservation observation);

  /// Retrieves all saved [BirdObservation]s from local storage.
  Future<List<BirdObservation>> getObservations();

  /// Deletes all saved observations from local storage.
  Future<void> clearHistory();
}