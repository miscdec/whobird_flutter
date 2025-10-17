import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/domain/repositories/audio_repository.dart';
import 'package:whobird_flutter/domain/repositories/classification_repository.dart';

class StartRealTimeAnalysis implements UseCase<Stream<List<Classification>>, NoParams> {
  final AudioRepository audioRepository;
  final ClassificationRepository classificationRepository;

  StartRealTimeAnalysis({
    required this.audioRepository,
    required this.classificationRepository,
  });

  @override
  Future<Stream<List<Classification>>> call(NoParams params) async* {
    await audioRepository.startRecording();
    yield* audioRepository.audioStream.asyncExpand((audioChunk) {
      return Stream.fromFuture(classificationRepository.classifyAudio(audioChunk));
    });
  }
}