import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/repositories/model_repository.dart';

class SetupApplicationUseCase implements UseCase<void, NoParams> {
  final ModelRepository modelRepository;

  SetupApplicationUseCase({required this.modelRepository});

  @override
  Future<void> call(NoParams params) async {
    final bool available = await modelRepository.areModelsAvailable();
    if (!available) {
      await modelRepository.downloadModels();
    }
  }
}