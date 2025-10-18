import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/repositories/audio_repository.dart';

class StopRealTimeAnalysis implements UseCase<void, NoParams> {
  final AudioRepository repository;

  StopRealTimeAnalysis(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.stopRecording();
  }
}