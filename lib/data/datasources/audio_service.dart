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

  @override
  Stream<AudioChunk> get audioStream => _audioChunkController.stream;

  @override
  Future<void> startRecording() async {
    // Note: Error handling and permission checks should be added here
    // or in a higher-level repository that uses this service.
    _stream = await MicStream.microphone(
      audioSource: AudioSource.DEFAULT,
      sampleRate: 48000,
      channelConfig: ChannelConfig.CHANNEL_IN_MONO,
      audioFormat: AudioFormat.ENCODING_PCM_16BIT,
    );

    _listener = _stream!.listen((samples) {
      // The mic_stream provides Uint8List, but our model expects Float32List.
      // The conversion and normalization logic will happen here or in the repo.
      // For now, we'll just pass a placeholder. This is a complex step
      // that depends on the exact model input requirements.
      final floatBuffer = Float32List(samples.lengthInBytes ~/ 2);
      // for (var i = 0; i < floatBuffer.length; i++) {
      //   var int16 = samples.buffer.asByteData().getInt16(i * 2, Endian.little);
      //   floatBuffer[i] = int16 / 32768.0;
      // }
      _audioChunkController.add(AudioChunk(buffer: floatBuffer));
    });
  }

  @override
  Future<void> stopRecording() async {
    await _listener?.cancel();
    _listener = null;
    _stream = null;
    if (!_audioChunkController.isClosed) {
      await _audioChunkController.close();
    }
  }
}