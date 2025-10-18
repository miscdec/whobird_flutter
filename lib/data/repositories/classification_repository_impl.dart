import 'package:whobird_flutter/core/error/failures.dart';
import 'package:whobird_flutter/data/datasources/ml_service.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/domain/repositories/classification_repository.dart';

class ClassificationRepositoryImpl implements ClassificationRepository {
  final MLService mlService;

  ClassificationRepositoryImpl({required this.mlService});

  @override
  Future<List<Classification>> classifyAudio(AudioChunk audioChunk) async {
    try {
      // The repository's job is to orchestrate data sources.
      // Here, it simply calls the ML service.
      // In a more complex app, it might combine results from multiple services.
      final results = await mlService.runInference(audioChunk);
      return results;
    } catch (e) {
      // The repository catches low-level exceptions and can rethrow them
      // as our defined `Failure` types, though we are simplifying for now.
      throw ServerFailure(message: 'Inference failed: $e');
    }
  }
}