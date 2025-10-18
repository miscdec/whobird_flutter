import 'package:whobird_flutter/core/error/failures.dart';
import 'package:whobird_flutter/data/datasources/location_service.dart';
import 'package:whobird_flutter/data/datasources/ml_service.dart';
import 'package:whobird_flutter/data/datasources/spectrogram_service.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/domain/repositories/classification_repository.dart';

class ClassificationRepositoryImpl implements ClassificationRepository {
  final MLService mlService;
  final LocationService locationService;
  final SpectrogramService spectrogramService;

  ClassificationRepositoryImpl({
    required this.mlService,
    required this.locationService,
    required this.spectrogramService,
  });

  @override
  Future<List<Classification>> classifyAudio(AudioChunk audioChunk) async {
    try {
      // 1. Convert raw audio to a spectrogram.
      final spectrogram = spectrogramService.createSpectrogram(audioChunk);

      // 2. Get location (can be done in parallel).
      final location = await locationService.getCurrentLocation();

      // 3. Run main inference on the spectrogram.
      final mainResults = await mlService.runInference(spectrogram);

      // 4. Placeholder for meta-model logic.
      // In a real implementation, you would run the meta-model here
      // using the location data and combine the results with mainResults.
      return mainResults;

    } catch (e) {
      throw ServerFailure(message: 'Classification pipeline failed: $e');
    }
  }
}