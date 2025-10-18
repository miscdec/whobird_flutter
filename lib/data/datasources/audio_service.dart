import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';

/// Abstract interface for a service that provides an audio stream.
abstract class AudioService {
  Stream<AudioChunk> get audioChunkStream;
  Future<void> startRecording();
  Future<void> stopRecording();
}

/// An implementation of AudioService that uses the `record` package.
class RecordAudioService implements AudioService {
  final AudioRecorder _audioRecorder = AudioRecorder();
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
    if (await _audioRecorder.isRecording()) {
      return;
    }

    const recorderConfig = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 48000,
      numChannels: 1,
    );

    final stream = await _audioRecorder.startStream(recorderConfig);

    stream.listen(
      (data) {
        _buffer.addAll(data);
        if (_buffer.length >= _chunkSizeBytes) {
          final chunkData = Uint8List.fromList(_buffer.sublist(0, _chunkSizeBytes));
          _buffer.removeRange(0, _chunkSizeBytes);

          final floatBuffer = _convertPcm16ToFloat32(chunkData);
          _audioChunkController?.add(AudioChunk(buffer: floatBuffer));
        }
      },
      // TODO: Add proper error handling
      onError: (error) => print('AudioStream Error: $error'),
      onDone: () => print('AudioStream Done'),
    );
  }

  @override
  Future<void> stopRecording() async {
    if (await _audioRecorder.isRecording()) {
      await _audioRecorder.stop();
    }
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