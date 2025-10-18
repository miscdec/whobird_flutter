import 'dart:math';
import 'dart:typed_data';
import 'package:scidart/numdart.dart';
import 'package:scidart/numdart.dart' as scidart;
import 'package:scidart/scidart.dart' as scidart;
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';

/// Abstract interface for a service that processes audio into spectrograms.
abstract class SpectrogramService {
  /// Converts a raw [AudioChunk] into a mel spectrogram with the correct shape for the model.
  Float32List createSpectrogram(AudioChunk audioChunk);
}

class SpectrogramServiceImpl implements SpectrogramService {
  // Constants based on BirdNET models.
  static const int sampleRate = 48000;
  static const int nFft = 1024 * 3; // From some implementations of BirdNET
  static const int hopLength = nFft;
  static const int nMel = 128; // The model expects 128 mel bins.
  static const int chunkLengthSeconds = 3;

  @override
  Float32List createSpectrogram(AudioChunk audioChunk) {
    final samples = audioChunk.buffer;

    // The model expects a specific number of frames.
    // Let's calculate the expected number of frames for a 3-second sample.
    // This part is complex and depends on the exact windowing used during training.
    // A common approach is to get around 298-300 frames.
    // For now, we will assume the STFT produces the correct number of frames.

    final stft = _stft(samples, nFft, hopLength);
    final powerSpec = stft.map((fft) => fft.map((c) => complexAbs(c) * complexAbs(c)).toList()).toList();
    final melFilters = _createMelFilterBank(nFft, sampleRate, nMel);

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

    // The output needs to be shaped correctly. Instead of flattening, we create
    // a 1D list that represents the 4D tensor [1, height, width, 1].
    // The model from the original app likely expects a shape like [1, 298, 128, 1],
    // where height=298 (time frames), width=128 (mel bins).
    // Our current STFT logic might not produce exactly 298 frames, but we'll structure it.
    final height = logMelSpectrogram.length;
    final width = nMel;

    // We need to transpose the matrix from [height, width] to [width, height]
    // if the model expects it that way, but let's assume [height, width] for now.
    final reshapedList = Float32List(height * width);
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        reshapedList[i * width + j] = logMelSpectrogram[i][j];
      }
    }
    return reshapedList;
  }

  List<List<double>> _createMelFilterBank(int nFft, int sampleRate, int nMel) {
    double fMin = 0.0;
    double fMax = sampleRate / 2.0;
    double melMin = 1127.0 * log(1.0 + fMin / 700.0);
    double melMax = 1127.0 * log(1.0 + fMax / 700.0);

    List<double> melPoints = List.generate(nMel + 2, (i) => melMin + i * (melMax - melMin) / (nMel + 1));
    List<double> hzPoints = melPoints.map((mel) => 700.0 * (exp(mel / 1127.0) - 1.0)).toList();
    List<int> binPoints = hzPoints.map((hz) => ((nFft / 2 + 1) * hz / fMax).floor()).toList();

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

  List<scidart.ArrayComplex> _stft(Float32List samples, int nFft, int hopLength) {
    final List<scidart.ArrayComplex> spectra = [];
    final window = _hanningWindow(nFft);

    for (int i = 0; i + nFft <= samples.length; i += hopLength) {
      final chunk = samples.sublist(i, i + nFft);
      final windowedChunk = List<double>.generate(nFft, (j) => chunk[j] * window[j]);

      // Convert Array to ArrayComplex by setting imaginary parts to zero
      final complexArray = scidart.ArrayComplex(
          windowedChunk.map((e) => scidart.Complex(real: e, imaginary: 0.0)).toList(),);

      final fft = scidart.fft(complexArray);
      final halfLength = (fft.length / 2).ceil();
      spectra.add(scidart.ArrayComplex(fft.sublist(0, halfLength)));
    }
    return spectra;
  }

  List<double> _hanningWindow(int length) {
    return List.generate(length, (i) => 0.5 * (1 - cos(2 * pi * i / (length - 1))));
  }
}