import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:whobird_flutter/core/constants/constants.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';

/// Abstract interface for a machine learning inference service.
abstract class MLService {
  /// Runs inference on a pre-processed [spectrogram].
  Future<List<Classification>> runInference(Float32List spectrogram);
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
  Future<List<Classification>> runInference(Float32List spectrogram) async {
    if (_interpreter == null || _metaInterpreter == null || _labels.isEmpty) {
      await loadModels();
    }

    final outputShape = [1, _labels.length];
    final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
        .reshape(outputShape);

    // The input is now the spectrogram
    final input = spectrogram.reshape([1, spectrogram.length]);

    try {
      _interpreter!.run(input, output);

      final List<Classification> results = [];
      final outputList = output[0] as List<double>;

      for (int i = 0; i < outputList.length; i++) {
        final score = 1 / (1 + exp(-outputList[i]));
        if (score > 0.01) {
          results.add(Classification(label: _labels[i], score: score));
        }
      }

      results.sort((a, b) => b.score.compareTo(a.score));
      return results;
    } catch (e) {
      print("Failed to run inference: $e");
      rethrow;
    }
  }
}