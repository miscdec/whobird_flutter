import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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
    on<StartAnalysis>(_onStartAnalysis, transformer: restartable());
    on<StopAnalysis>(_onStopAnalysis);
    on<_NewDetectionsReceived>(_onNewDetectionsReceived);
  }

  Future<void> _onStartAnalysis(
    StartAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(const AnalysisInProgress([]));
    try {
      final stream = await startRealTimeAnalysis(NoParams());
      await emit.forEach(
        stream,
        onData: (List<Classification> detections) => AnalysisInProgress(detections),
        onError: (error, stackTrace) => AnalysisFailure(error.toString()),
      );
    } catch (error) {
      emit(AnalysisFailure(error.toString()));
    }
  }

  Future<void> _onStopAnalysis(
    StopAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    // The restartable transformer handles cancelling the previous stream,
    // but we can also manually stop it if needed.
    // For now, simply emitting a paused state is enough.
    emit(AnalysisPaused());
  }

  void _onNewDetectionsReceived(
    _NewDetectionsReceived event,
    Emitter<AnalysisState> emit,
  ) {
    // This event is now handled by emit.forEach, but we can keep it
    // for other purposes or remove it if it's no longer needed.
    // For clarity, we will rely on emit.forEach and this event can be removed later.
    emit(AnalysisInProgress(event.detections));
  }
}