
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/audio_repository.dart';
import '../repositories/classification_repository.dart';

class StopRealTimeAnalysis implements UseCase<void, NoParams> {
  final AudioRepository repository;

  StopRealTimeAnalysis(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.stopRecording();
  }
}