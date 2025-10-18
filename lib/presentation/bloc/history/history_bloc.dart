import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/bird_observation.dart';
import 'package:whobird_flutter/domain/usecases/get_observation_history.dart';
import 'package:whobird_flutter/domain/usecases/clear_observation_history.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetObservationHistory getObservationHistory;
  final ClearObservationHistory clearObservationHistory;

  HistoryBloc({
    required this.getObservationHistory,
    required this.clearObservationHistory,
  }) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<ClearHistory>(_onClearHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final observations = await getObservationHistory(NoParams());
      if (observations.isEmpty) {
        emit(HistoryEmpty());
      } else {
        emit(HistoryLoaded(observations));
      }
    } catch (e) {
      emit(HistoryFailure(e.toString()));
    }
  }

  Future<void> _onClearHistory(
    ClearHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      await clearObservationHistory(NoParams());
      emit(HistoryEmpty());
    } catch (e) {
      emit(HistoryFailure(e.toString()));
    }
  }
}