import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppSettings extends Equatable {
  /// The minimum probability required for a detection to be displayed.
  /// Range: 0.0 to 1.0.
  final double probabilityThreshold;

  /// Whether to download and display an image of the detected bird.
  final bool showImages;

  /// The selected audio input source.
  final String audioSource;

  /// The frequency for the high-pass filter to reduce background noise.
  /// A value of 0 means the filter is disabled.
  final int highPassFilterHz;

  /// The influence of the location-based meta model on the final result.
  /// Range: 0.0 to 1.0.
  final double metaModelInfluence;

  /// Whether to save a .wav file for each detection.
  final bool saveWavFiles;

  const AppSettings({
    required this.probabilityThreshold,
    required this.showImages,
    required this.audioSource,
    required this.highPassFilterHz,
    required this.metaModelInfluence,
    required this.saveWavFiles,
  });

  @override
  List<Object?> get props => [
        probabilityThreshold,
        showImages,
        audioSource,
        highPassFilterHz,
        metaModelInfluence,
        saveWavFiles,
      ];
}