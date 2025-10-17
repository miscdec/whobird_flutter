import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Classification extends Equatable {
  /// The raw label from the model, e.g., "Passer domesticus_House Sparrow".
  final String label;

  /// The confidence score from the model, typically between 0.0 and 1.0.
  final double score;

  const Classification({
    required this.label,
    required this.score,
  });

  @override
  List<Object?> get props => [label, score];
}