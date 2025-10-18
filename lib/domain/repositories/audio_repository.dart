import 'package:whobird_flutter/domain/entities/audio_chunk.dart';

/// The contract for accessing the device's microphone and managing audio state.
abstract class AudioRepository {
  /// Provides a stream of [AudioChunk]s from the microphone.
  Stream<AudioChunk> get audioChunkStream;

  /// Requests audio focus and starts the recording process.
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> startRecording();

  /// Stops the recording process and abandons audio focus.
  Future<void> stopRecording();
}