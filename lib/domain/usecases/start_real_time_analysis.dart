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
  Future<Stream<List<Classification>>> call(NoParams params) async* {
    final bool permissionsGranted = await permissionRepository.requestPermissions();
    if (!permissionsGranted) {
      // If permissions are not granted, we can throw a specific failure
      // or return an empty stream with an error.
      throw PermissionFailure(message: 'Microphone and location permissions are required.');
    }

    await audioRepository.startRecording();
    yield* audioRepository.audioStream.asyncExpand((audioChunk) {
      return Stream.fromFuture(classificationRepository.classifyAudio(audioChunk));
    });
  }
}