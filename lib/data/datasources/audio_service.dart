import 'dart:async';
import 'dart:typed_data';
import 'package:mic_stream/mic_stream.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';

/// Abstract interface for a service that provides an audio stream.
abstract class AudioService {
  Stream<AudioChunk> get audioStream;
  Future<void> startRecording();
  Future<void> stopRecording();
}

/// An implementation of AudioService that uses the `mic_stream` package.
class MicStreamAudioService implements AudioService {
  Stream<Uint8List>? _stream;
  StreamSubscription<Uint8List>? _listener;
  final _audioChunkController = StreamController<AudioChunk>();

  // A buffer to hold audio data until we have a full 3-second chunk
  final List<int> _buffer = [];
  // 3 seconds * 48000 samples/sec * 2 bytes/sample (16-bit) = 288000 bytes
  static const int _chunkSizeBytes = 288000;

  @override
  Stream<AudioChunk> get audioStream => _audioChunkController.stream;

  @override
  Future<void> startRecording() async {
    await stopRecording(); // Ensure any previous stream is stopped.

    _stream = await MicStream.microphone(
      audioSource: AudioSource.DEFAULT,
      sampleRate: 48000,
      channelConfig: ChannelConfig.CHANNEL_IN_MONO,
      audioFormat: AudioFormat.ENCODING_PCM_16BIT,
    );

    _listener = _stream!.listen((samples) {
      _buffer.addAll(samples);
      // When the buffer has enough data for a full chunk, process and emit it.
      if (_buffer.length >= _chunkSizeBytes) {
        final chunkData = Uint8List.fromList(_buffer.sublist(0, _chunkSizeBytes));
        _buffer.removeRange(0, _chunkSizeBytes); // Keep the buffer clean

        // Convert Uint8List (16-bit PCM) to Float32List (-1.0 to 1.0)
        final floatBuffer = _convertPcm16ToFloat32(chunkData);
        _audioChunkController.add(AudioChunk(buffer: floatBuffer));
      }
    });
  }

  @override
  Future<void> stopRecording() async {
    await _listener?.cancel();
    _listener = null;
    _stream = null;
    _buffer.clear();
  }

  Float32List _convertPcm16ToFloat32(Uint8List pcm16) {
    final byteData = pcm16.buffer.asByteData();
    final float32List = Float32List(byteData.lengthInBytes ~/ 2);
    for (var i = 0; i < float32List.length; i++) {
      // Read two bytes as a 16-bit signed integer (little-endian)
      final int16 = byteData.getInt16(i * 2, Endian.little);
      // Normalize to the range -1.0 to 1.0
      float32List[i] = int16 / 32768.0;
    }
    return float32List;
  }
}