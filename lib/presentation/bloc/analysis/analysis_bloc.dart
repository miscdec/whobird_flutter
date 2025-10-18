import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/domain/usecases/start_real_time_analysis.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final StartRealTimeAnalysis startRealTimeAnalysis;
  StreamSubscription<List<Classification>>? _analysisSubscription;

  AnalysisBloc({required this.startRealTimeAnalysis}) : super(AnalysisInitial()) {
    on<StartAnalysis>(_onStartAnalysis);
    on<StopAnalysis>(_onStopAnalysis);
    on<_NewDetectionsReceived>(_onNewDetectionsReceived);
  }

  Future<void> _onStartAnalysis(
    StartAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    await _analysisSubscription?.cancel();
    final stream = await startRealTimeAnalysis(NoParams());
    _analysisSubscription = stream.listen(
      (detections) => add(_NewDetectionsReceived(detections)),
      onError: (error) => emit(AnalysisFailure(error.toString())),
    );
    emit(const AnalysisInProgress([]));
  }

  Future<void> _onStopAnalysis(
    StopAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    await _analysisSubscription?.cancel();
    _analysisSubscription = null;
    emit(AnalysisPaused());
  }

  void _onNewDetectionsReceived(
    _NewDetectionsReceived event,
    Emitter<AnalysisState> emit,
  ) {
    emit(AnalysisInProgress(event.detections));
  }

  @override
  Future<void> close() {
    _analysisSubscription?.cancel();
    return super.close();
  }
}