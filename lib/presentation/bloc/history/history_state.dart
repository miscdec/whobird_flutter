part of 'history_bloc.dart';

@immutable
abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<BirdObservation> observations;

  const HistoryLoaded(this.observations);

  @override
  List<Object> get props => [observations];
}

class HistoryEmpty extends HistoryState {}

class HistoryFailure extends HistoryState {
  final String message;

  const HistoryFailure(this.message);

  @override
  List<Object> get props => [message];
}