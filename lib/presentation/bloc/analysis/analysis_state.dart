part of 'analysis_bloc.dart';

@immutable
abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object> get props => [];
}

class AnalysisInitial extends AnalysisState {}

class AnalysisInProgress extends AnalysisState {
  final List<Classification> detections;

  const AnalysisInProgress(this.detections);

  @override
  List<Object> get props => [detections];
}

class AnalysisPaused extends AnalysisState {}

class AnalysisFailure extends AnalysisState {
  final String message;

  const AnalysisFailure(this.message);

  @override
  List<Object> get props => [message];
}