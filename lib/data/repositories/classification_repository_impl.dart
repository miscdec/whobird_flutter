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
  Map<String, int>? _labelIndexMap;

  ClassificationRepositoryImpl({
    required this.mlService,
    required this.locationService,
    required this.spectrogramService,
  });

  @override
  Future<List<Classification>> classifyAudio(AudioChunk audioChunk) async {
    try {
      final spectrogram = spectrogramService.createSpectrogram(audioChunk);
      final resultsFuture = mlService.runInference(spectrogram);
      final locationFuture = locationService.getCurrentLocation();

      final mainResults = await resultsFuture;
      final location = await locationFuture;

      final now = DateTime.now();
      final weekOfYear = ((now.difference(DateTime(now.year, 1, 1)).inDays) / 7).ceil();

      final metaScores = await mlService.runMetaInference(
        location: location,
        weekOfYear: weekOfYear,
      );

      final List<Classification> finalResults = [];
      for (final result in mainResults) {
        final labelIndex = _getLabelIndex(result.label);
        if (labelIndex != -1) {
          final metaScore = metaScores[labelIndex];
          final finalScore = (result.score * 0.5) + (metaScore * 0.5);

          if (finalScore > 0.1) {
             finalResults.add(Classification(label: result.label, score: finalScore));
          }
        }
      }

      finalResults.sort((a, b) => b.score.compareTo(a.score));
      return finalResults;

    } catch (e) {
      throw ServerFailure(message: 'Classification pipeline failed: $e');
    }
  }

  int _getLabelIndex(String label) {
    _labelIndexMap ??= {
        for (var i = 0; i < mlService.labels.length; i++) mlService.labels[i]: i
      };
    return _labelIndexMap![label] ?? -1;
  }
}