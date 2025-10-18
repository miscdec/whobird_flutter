import 'dart:math';
import 'dart:typed_data';
import 'package:fft/fft.dart';
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
    // 1. Normalize and downsample if necessary (assuming input is already correct for now)
    final samples = audioChunk.buffer;

    // 2. Create Mel filter bank
    final melFilters = _createMelFilterBank(nFft, sampleRate, nMel);

    // 3. Apply Hanning window and perform STFT
    final stft = _stft(samples, nFft, hopLength);

    // 4. Compute power spectrogram
    final powerSpec = stft.map((fft) {
      return fft.map((c) => c.abs() * c.abs()).toList();
    }).toList();

    // 5. Apply Mel filter bank
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

    // 6. Log-scale and flatten
    final logMelSpectrogram = melSpectrogram.map((frame) {
      return frame.map((val) => log(val + 1e-6)).toList();
    }).toList();

    // Flatten the 2D list into a 1D list for the model
    final flattened = logMelSpectrogram.expand((row) => row).toList();
    return Float32List.fromList(flattened);
  }

  /// Creates a bank of Mel-scaled filters.
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

  /// Performs Short-Time Fourier Transform.
  List<List<Complex>> _stft(Float32List samples, int nFft, int hopLength) {
    final List<List<Complex>> spectra = [];
    final window = _hanningWindow(nFft);

    for (int i = 0; i + nFft <= samples.length; i += hopLength) {
      final chunk = samples.sublist(i, i + nFft);
      final windowedChunk = List<double>.generate(nFft, (j) => chunk[j] * window[j]);

      final fft = FFT().Transform(windowedChunk);
      spectra.add(fft.sublist(0, nFft ~/ 2 + 1));
    }
    return spectra;
  }

  /// Generates a Hanning window.
  List<double> _hanningWindow(int length) {
    return List.generate(length, (i) => 0.5 * (1 - cos(2 * pi * i / (length - 1))));
  }
}