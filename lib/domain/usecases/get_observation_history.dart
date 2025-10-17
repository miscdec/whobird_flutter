import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/bird_observation.dart';
import 'package:whobird_flutter/domain/repositories/observation_history_repository.dart';

class GetObservationHistory implements UseCase<List<BirdObservation>, NoParams> {
  final ObservationHistoryRepository repository;

  GetObservationHistory(this.repository);

  @override
  Future<List<BirdObservation>> call(NoParams params) async {
    return await repository.getObservations();
  }
}