import 'dart:async';
import 'dart:typed_data';
import 'package:mic_stream/mic_stream.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';

/// Abstract interface for a service that provides an audio stream.
abstract class AudioService {
  Stream<AudioChunk> get audioChunkStream;
  Future<void> startRecording();
  Future<void> stopRecording();
}

/// An implementation of AudioService that uses the `mic_stream` package.
class MicStreamAudioService implements AudioService {
  StreamSubscription<Uint8List>? _micSubscription;
  StreamController<AudioChunk>? _audioChunkController;

  final List<int> _buffer = [];
  static const int _chunkSizeBytes = 288000;

  @override
  Stream<AudioChunk> get audioChunkStream {
    _audioChunkController ??= StreamController<AudioChunk>.broadcast();
    return _audioChunkController!.stream;
  }

  @override
  Future<void> startRecording() async {
    // If the subscription is already active, do nothing.
    if (_micSubscription != null) return;

    final stream = await MicStream.microphone(
      audioSource: AudioSource.DEFAULT,
      sampleRate: 48000,
      channelConfig: ChannelConfig.CHANNEL_IN_MONO,
      audioFormat: AudioFormat.ENCODING_PCM_16BIT,
    );

    _micSubscription = stream.listen((samples) {
      _buffer.addAll(samples);
      if (_buffer.length >= _chunkSizeBytes) {
        final chunkData = Uint8List.fromList(_buffer.sublist(0, _chunkSizeBytes));
        _buffer.removeRange(0, _chunkSizeBytes);

        final floatBuffer = _convertPcm16ToFloat32(chunkData);
        _audioChunkController?.add(AudioChunk(buffer: floatBuffer));
      }
    });
  }

  @override
  Future<void> stopRecording() async {
    await _micSubscription?.cancel();
    _micSubscription = null;
    _buffer.clear();
  }

  Float32List _convertPcm16ToFloat32(Uint8List pcm16) {
    final byteData = pcm16.buffer.asByteData();
    final float32List = Float32List(byteData.lengthInBytes ~/ 2);
    for (var i = 0; i < float32List.length; i++) {
      final int16 = byteData.getInt16(i * 2, Endian.little);
      float32List[i] = int16 / 32768.0;
    }
    return float32List;
  }
}