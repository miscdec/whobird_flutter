import 'package:whobird_flutter/domain/entities/audio_chunk.dart';

/// The contract for accessing the device's microphone.
///
/// The implementation of this contract will be in the Data layer.
abstract class AudioRepository {
  /// Provides a stream of [AudioChunk]s from the microphone.
  Stream<AudioChunk> get audioStream;

  /// Starts the recording process.
  Future<void> startRecording();

  /// Stops the recording process.
  Future<void> stopRecording();
}