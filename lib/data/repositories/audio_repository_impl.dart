import 'package:whobird_flutter/data/datasources/audio_focus_service.dart';
import 'package:whobird_flutter/data/datasources/audio_service.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';
import 'package:whobird_flutter/domain/repositories/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioService audioService;
  final AudioFocusService audioFocusService;

  AudioRepositoryImpl({
    required this.audioService,
    required this.audioFocusService,
  });

  @override
  Stream<AudioChunk> get audioStream => audioService.audioStream;

  @override
  Future<bool> startRecording() async {
    final bool focusGranted = await audioFocusService.requestAudioFocus();
    if (focusGranted) {
      await audioService.startRecording();
      return true;
    }
    return false;
  }

  @override
  Future<void> stopRecording() async {
    await audioService.stopRecording();
    await audioFocusService.abandonAudioFocus();
  }
}