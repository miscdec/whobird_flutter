import 'package:whobird_flutter/data/datasources/audio_service.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';
import 'package:whobird_flutter/domain/repositories/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioService audioService;

  AudioRepositoryImpl({required this.audioService});

  @override
  Stream<AudioChunk> get audioStream => audioService.audioStream;

  @override
  Future<void> startRecording() {
    return audioService.startRecording();
  }

  @override
  Future<void> stopRecording() {
    return audioService.stopRecording();
  }
}