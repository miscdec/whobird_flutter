part of 'analysis_bloc.dart';

@immutable
abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();

  @override
  List<Object> get props => [];
}

class StartAnalysis extends AnalysisEvent {}

class StopAnalysis extends AnalysisEvent {}