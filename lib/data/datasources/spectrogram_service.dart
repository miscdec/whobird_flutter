import 'dart:math';
import 'dart:typed_data';
import 'package:scidart/scidart.dart' as scidart;
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';

/// Abstract interface for a service that processes audio into spectrograms.
abstract class SpectrogramService {
  /// Converts a raw [AudioChunk] into a mel spectrogram.
  Float32List createSpectrogram(AudioChunk audioChunk);
}

class SpectrogramServiceImpl implements SpectrogramService {
  // Constants based on the original MelSpectrogram.java
  static const int sampleRate = 48000;
  static const int nFft = 2400; // Corresponds to a window size of 50ms
  static const int hopLength = 480; // 10ms hop
  static const int nMel = 128;

  @override
  Float32List createSpectrogram(AudioChunk audioChunk) {
    final samples = audioChunk.buffer;
    final melFilters = _createMelFilterBank(nFft, sampleRate, nMel);
    final stft = _stft(samples, nFft, hopLength);

    // Correctly calculate power spectrum
    final powerSpec = stft.map((fft) {
      return fft.map((c) => c.abs() * c.abs()).toList();
    }).toList();

    final melSpectrogram = powerSpec.map((frame) {
      final melFrame = List<double>.filled(nMel, 0.0);
      for (int i = 0; i < nMel; i++) {
        double sum = 0.0;
        for (int j = 0; j < frame.length; j++) {
          sum += frame[j] * melFilters[i][j];
        }
        melFrame[i] = sum;
      }
      return melFrame;
    }).toList();

    final logMelSpectrogram = melSpectrogram.map((frame) {
      return frame.map((val) => log(val + 1e-6)).toList();
    }).toList();

    final flattened = logMelSpectrogram.expand((row) => row).toList();
    return Float32List.fromList(flattened);
  }

  List<List<double>> _createMelFilterBank(int nFft, int sampleRate, int nMel) {
    double fMin = 0.0;
    double fMax = sampleRate / 2.0;
    double melMin = 1127.0 * log(1.0 + fMin / 700.0);
    double melMax = 1127.0 * log(1.0 + fMax / 700.0);

    List<double> melPoints = List.generate(nMel + 2, (i) => melMin + i * (melMax - melMin) / (nMel + 1));
    List<double> hzPoints = melPoints.map((mel) => 700.0 * (exp(mel / 1127.0) - 1.0)).toList();
    List<int> binPoints = hzPoints.map((hz) => (nFft / 2 + 1) * hz / fMax).floor().toList();

    List<List<double>> filters = List.generate(nMel, (i) => List<double>.filled(nFft ~/ 2 + 1, 0.0));

    for (int i = 0; i < nMel; i++) {
      for (int j = binPoints[i]; j < binPoints[i + 1]; j++) {
        filters[i][j] = (j - binPoints[i]) / (binPoints[i + 1] - binPoints[i]);
      }
      for (int j = binPoints[i + 1]; j < binPoints[i + 2]; j++) {
        filters[i][j] = (binPoints[i + 2] - j) / (binPoints[i + 2] - binPoints[i + 1]);
      }
    }
    return filters;
  }

  /// Performs Short-Time Fourier Transform using scidart.
  List<scidart.ArrayComplex> _stft(Float32List samples, int nFft, int hopLength) {
    final List<scidart.ArrayComplex> spectra = [];
    final window = _hanningWindow(nFft);

    for (int i = 0; i + nFft <= samples.length; i += hopLength) {
      final chunk = samples.sublist(i, i + nFft);
      final windowedChunk = List<double>.generate(nFft, (j) => chunk[j] * window[j]);

      final fft = scidart.fft(scidart.Array(windowedChunk));
      final halfLength = (fft.length / 2).ceil();
      spectra.add(fft.sublist(0, halfLength));
    }
    return spectra;
  }

  List<double> _hanningWindow(int length) {
    return List.generate(length, (i) => 0.5 * (1 - cos(2 * pi * i / (length - 1))));
  }
}