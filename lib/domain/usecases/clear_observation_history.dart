import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/repositories/observation_history_repository.dart';

class ClearObservationHistory implements UseCase<void, NoParams> {
  final ObservationHistoryRepository repository;

  ClearObservationHistory(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.clearHistory();
  }
}