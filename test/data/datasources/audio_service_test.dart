import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whobird_flutter/data/datasources/audio_service.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';

// We cannot easily mock static methods like MicStream.microphone,
// so we will test the conversion logic directly and trust the plugin
// to provide the stream. A full integration test would be needed
// to test the hardware interaction.

// For this unit test, we will focus on the buffering and conversion logic.
// We can do this by extending the class and overriding the startRecording method.

class TestableMicStreamAudioService extends MicStreamAudioService {
  final StreamController<Uint8List> testStreamController = StreamController();

  final List<int> _buffer = [];
  final int _chunkSize = 1024;
  late Stream<Uint8List>? _stream;
  late StreamSubscription<Uint8List>? _listener;
  final StreamController<AudioChunk> _audioChunkController = StreamController();

  @override
  Future<void> startRecording() async {
    // Override to use our test controller instead of the real microphone
    _stream = testStreamController.stream;
    _listener = _stream!.listen((samples) {
      _buffer.addAll(samples);
      if (_buffer.length >= _chunkSize) {
        final chunkData = Uint8List.fromList(_buffer.sublist(0, _chunkSize));
        _buffer.removeRange(0, _chunkSize);
        final floatBuffer = _convertPcm16ToFloat32(chunkData);
        _audioChunkController.add(AudioChunk(buffer: floatBuffer));
      }
    });
  }
}

void main() {
  late TestableMicStreamAudioService service;

  setUp(() {
    service = TestableMicStreamAudioService();
  });

  tearDown(() {
    service.stopRecording();
  });

  test('should buffer and convert audio data correctly', () async {
    // Arrange
    // Create a sample 16-bit PCM byte array.
    // Let's say one sample is 10000 (0x2710). In little-endian, it's [0x10, 0x27].
    final sampleBytes = Uint8List.fromList([0x10, 0x27, 0x10, 0x27]); // Two samples

    // We need to create enough data to fill the chunk
    final fullChunk = Uint8List(_chunkSize);
    for (int i = 0; i < fullChunk.length; i += 2) {
      fullChunk[i] = 0x10;
      fullChunk[i + 1] = 0x27;
    }

    // Act
    service.startRecording();

    // Expect one chunk to be emitted
    final future = service.audioStream.first;

    // Add the data to the test stream
    service.testStreamController.add(fullChunk);

    final result = await future;

    // Assert
    expect(result, isA<AudioChunk>());
    expect(result.buffer.length, _chunkSize ~/ 2);
    // 10000 / 32768.0 = 0.30517578125
    expect(result.buffer[0], closeTo(0.305, 0.001));
    expect(result.buffer[1], closeTo(0.305, 0.001));
  });
}