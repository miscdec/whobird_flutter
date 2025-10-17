import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/bird_observation.dart';
import 'package:whobird_flutter/domain/repositories/observation_history_repository.dart';

class SaveDetection implements UseCase<void, BirdObservation> {
  final ObservationHistoryRepository repository;

  SaveDetection(this.repository);

  @override
  Future<void> call(BirdObservation params) async {
    return await repository.saveObservation(params);
  }
}