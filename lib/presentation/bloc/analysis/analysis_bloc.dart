import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:whobird_flutter/core/error/failures.dart';
import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/domain/usecases/start_real_time_analysis.dart';
import 'package:whobird_flutter/domain/usecases/stop_real_time_analysis.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final StartRealTimeAnalysis startRealTimeAnalysis;
  final StopRealTimeAnalysis stopRealTimeAnalysis;

  AnalysisBloc({
    required this.startRealTimeAnalysis,
    required this.stopRealTimeAnalysis,
  }) : super(AnalysisInitial()) {
    on<StartAnalysis>(_onStartAnalysis, transformer: restartable());
    on<StopAnalysis>(_onStopAnalysis);
  }

  Future<void> _onStartAnalysis(
    StartAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(const AnalysisInProgress([]));
    try {
      final stream = await startRealTimeAnalysis(NoParams());
      await emit.forEach<List<Classification>>(
        stream,
        onData: (detections) => AnalysisInProgress(detections),
        onError: (error, stackTrace) {
          if (error is PermissionFailure) {
            return AnalysisFailure("Permissions not granted. Please grant microphone and location permissions.");
          }
          return AnalysisFailure(error.toString());
        },
      );
    } on PermissionFailure catch (e) {
      emit(AnalysisFailure(e.message));
    } catch (e) {
      emit(AnalysisFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onStopAnalysis(
    StopAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      await stopRealTimeAnalysis(NoParams());
      emit(AnalysisPaused());
    } catch (e) {
      emit(AnalysisFailure("Failed to stop analysis: ${e.toString()}"));
    }
  }
}