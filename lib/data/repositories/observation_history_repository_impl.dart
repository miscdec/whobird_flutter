import 'package:whobird_flutter/core/error/failures.dart';
import 'package:whobird_flutter/data/datasources/persistence_service.dart';
import 'package:whobird_flutter/domain/entities/bird_observation.dart';
import 'package:whobird_flutter/domain/repositories/observation_history_repository.dart';

class ObservationHistoryRepositoryImpl implements ObservationHistoryRepository {
  final PersistenceService persistenceService;

  ObservationHistoryRepositoryImpl({required this.persistenceService});

  @override
  Future<void> saveObservation(BirdObservation observation) async {
    try {
      return await persistenceService.saveObservation(observation);
    } catch (e) {
      throw CacheFailure(message: 'Failed to save observation: $e');
    }
  }

  @override
  Future<List<BirdObservation>> getObservations() async {
    try {
      return await persistenceService.getObservations();
    } catch (e) {
      throw CacheFailure(message: 'Failed to retrieve observations: $e');
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      return await persistenceService.clearHistory();
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear history: $e');
    }
  }
}