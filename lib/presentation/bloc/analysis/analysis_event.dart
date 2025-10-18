part of 'analysis_bloc.dart';

@immutable
abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();

  @override
  List<Object> get props => [];
}

class StartAnalysis extends AnalysisEvent {}

class StopAnalysis extends AnalysisEvent {}

class _NewDetectionsReceived extends AnalysisEvent {
  final List<Classification> detections;

  const _NewDetectionsReceived(this.detections);

  @override
  List<Object> get props => [detections];
}