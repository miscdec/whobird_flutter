import 'dart:typed_data';

import 'package.equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class AudioChunk extends Equatable {
  /// The raw audio data buffer.
  final Float32List buffer;

  const AudioChunk({required this.buffer});

  @override
  List<Object?> get props => [buffer];
}