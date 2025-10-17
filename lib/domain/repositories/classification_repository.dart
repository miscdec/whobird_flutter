import 'package:whobird_flutter/core/error/failures.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';

/// The contract for classifying audio data.
///
/// The implementation of this contract will be in the Data layer.
abstract class ClassificationRepository {
  /// Takes an [AudioChunk] and returns a list of [Classification] results.
  ///
  /// Throws a [Failure] on error. A more robust implementation might use
  /// the Either type from a functional programming package to handle failures.
  Future<List<Classification>> classifyAudio(AudioChunk audioChunk);
}