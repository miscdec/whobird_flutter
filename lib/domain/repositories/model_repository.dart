abstract class ModelRepository {
  Future<bool> areModelsAvailable();
  Future<void> downloadModels();
}