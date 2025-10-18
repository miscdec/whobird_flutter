import 'package:whobird_flutter/core/error/failures.dart';
import 'package:whobird_flutter/data/datasources/location_service.dart';
import 'package:whobird_flutter/data/datasources/ml_service.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/domain/repositories/classification_repository.dart';

class ClassificationRepositoryImpl implements ClassificationRepository {
  final MLService mlService;
  final LocationService locationService;

  ClassificationRepositoryImpl({
    required this.mlService,
    required this.locationService,
  });

  @override
  Future<List<Classification>> classifyAudio(AudioChunk audioChunk) async {
    try {
      // The repository's job is to orchestrate data sources.
      // 1. Get location (can be done in parallel with main inference if optimized)
      final location = await locationService.getCurrentLocation();

      // 2. Run main inference
      final mainResults = await mlService.runInference(audioChunk);

      // 3. Run meta model inference (This logic is simplified.
      // In the original app, the meta model takes lat, long, and week of year)
      // We'll simulate this by applying a simple filter or a weighted score.
      // For now, we will just pass the main results through. A more complex
      // implementation of the meta model would happen inside the MLService.

      // 4. Combine results (Placeholder logic)
      // This is where the scores from the main model would be combined
      // with the scores from the meta model. For now, we return the sorted
      // main results directly.
      return mainResults;

    } catch (e) {
      // The repository catches low-level exceptions and can rethrow them
      // as our defined `Failure` types.
      throw ServerFailure(message: 'Inference failed: $e');
    }
  }
}