import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:whobird_flutter/core/constants/constants.dart';
import 'package:whobird_flutter/core/error/failures.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/data/datasources/location_service.dart';

/// Abstract interface for a machine learning inference service.
abstract class MLService {
  List<String> get labels;
  Future<List<Classification>> runInference(Float32List spectrogram);
  Future<List<double>> runMetaInference({required Location location, required int weekOfYear});
  Future<void> loadModels();
}

/// A service that uses the TFLite Flutter plugin to run inference.
class TfLiteService implements MLService {
  Interpreter? _interpreter;
  Interpreter? _metaInterpreter;
  List<String> _labels = [];

  @override
  List<String> get labels => _labels;

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
      throw ModelLoadFailure(message: "Failed to load models: $e");
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

    // The model expects a 4D tensor: [1, height, width, 1]
    // The spectrogram service provides a 1D list representing a 2D spectrogram.
    // We need to know the height and width to reshape it correctly.
    // Assuming height ~298, width 128 from common BirdNET implementations.
    // This is a critical point that must match the spectrogram service output.
    final height = spectrogram.length ~/ 128;
    final width = 128;
    final input = spectrogram.reshape([1, height, width, 1]);

    final outputShape = [1, _labels.length];
    final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
        .reshape(outputShape);

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
      // print("Results: $results");
      return results;
    } catch (e) {
      print("Failed to run inference: $e");
      rethrow;
    }
  }

  @override
  Future<List<double>> runMetaInference({required Location location, required int weekOfYear}) async {
    if (_metaInterpreter == null) {
      await loadModels();
    }

    final weekMeta = cos(2 * pi * weekOfYear / 52.0);
    final input = [location.latitude, location.longitude, weekMeta];

    final outputShape = [1, _labels.length];
    final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
        .reshape(outputShape);

    try {
      _metaInterpreter!.run(input, output);
      return output[0] as List<double>;
    } catch (e) {
      print("Failed to run meta inference: $e");
      rethrow;
    }
  }
}