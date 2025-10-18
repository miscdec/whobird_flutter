import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:whobird_flutter/core/constants/constants.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';

/// Abstract interface for a machine learning inference service.
abstract class MLService {
  Future<List<Classification>> runInference(AudioChunk audioChunk);
  Future<void> loadModels();
}

/// A service that uses the TFLite Flutter plugin to run inference.
class TfLiteService implements MLService {
  Interpreter? _interpreter;
  Interpreter? _metaInterpreter;
  List<String> _labels = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<void> loadModels() async {
    try {
      final path = await _localPath;
      _interpreter = await Interpreter.fromFile(File('$path/$kModelFileName'));
      _metaInterpreter = await Interpreter.fromFile(File('$path/$kMetaModelFileName'));
      await _loadLabels();
    } catch (e) {
      print("Failed to load models: $e");
      rethrow;
    }
  }

  Future<void> _loadLabels() async {
    final path = await _localPath;
    final labelsFile = File('$path/$kLabelsFileName');
    _labels = await labelsFile.readAsLines();
  }

  @override
  Future<List<Classification>> runInference(AudioChunk audioChunk) async {
    if (_interpreter == null || _metaInterpreter == null || _labels.isEmpty) {
      await loadModels();
    }

    // 1. Define input and output shapes based on the model.
    // This is based on the original whoBIRD app's SoundClassifier.kt
    final outputShape = [1, _labels.length];
    final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
        .reshape(outputShape);

    // Assuming audioChunk buffer is already the correct size (144000 for 3s at 48kHz)
    final input = audioChunk.buffer.reshape([1, audioChunk.buffer.length]);

    try {
      // 2. Run inference
      _interpreter!.run(input, output);

      // 3. Post-processing
      final List<Classification> results = [];
      final outputList = output[0] as List<double>;

      for (int i = 0; i < outputList.length; i++) {
        // Apply sigmoid function to convert logits to probabilities
        final score = 1 / (1 + exp(-outputList[i]));
        if (score > 0.01) { // A threshold to avoid adding too many low-confidence results
          results.add(Classification(label: _labels[i], score: score));
        }
      }

      // Sort by score descending
      results.sort((a, b) => b.score.compareTo(a.score));

      return results;
    } catch (e) {
      print("Failed to run inference: $e");
      rethrow;
    }
  }
}