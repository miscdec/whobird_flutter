import 'package:equatable/equatable.dart';
import 'package:whobird_flutter/core/error/failures.dart';
import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/domain/repositories/audio_repository.dart';
import 'package:whobird_flutter/domain/repositories/classification_repository.dart';
import 'package:whobird_flutter/domain/repositories/permission_repository.dart';

class StartRealTimeAnalysis implements UseCase<Stream<List<Classification>>, NoParams> {
  final AudioRepository audioRepository;
  final ClassificationRepository classificationRepository;
  final PermissionRepository permissionRepository;

  StartRealTimeAnalysis({
    required this.audioRepository,
    required this.classificationRepository,
    required this.permissionRepository,
  });

  @override
  Future<Stream<List<Classification>>> call(NoParams params) async {
    final bool permissionsGranted = await permissionRepository.requestPermissions();
    if (!permissionsGranted) {
      // If permissions are not granted, we can throw a specific failure
      // or return an empty stream with an error.
      throw PermissionFailure(message: 'Microphone and location permissions are required.');
    }

    final bool recordingStarted = await audioRepository.startRecording();
    if (!recordingStarted) {
      await audioRepository.stopRecording();
      // This could be a specific failure for audio focus.
      throw PermissionFailure(message: 'Could not get audio focus.');

    }

    try {
      return audioRepository.audioStream.asyncMap((audioChunk) {
        return classificationRepository.classifyAudio(audioChunk);
      });
    } catch (e) {
      await audioRepository.stopRecording();
      // This could be a specific failure for audio focus.
      throw RecordFailure(message: 'An error occurred during audio processing: ${e.toString()}');
    }

  }
}