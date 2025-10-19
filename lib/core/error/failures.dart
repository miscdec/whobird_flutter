import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String message;

  const ServerFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ModelLoadFailure extends Failure {
  final String message;

  const ModelLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  final String message;

  const CacheFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class PermissionFailure extends Failure {
  final String message;

  const PermissionFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class RecordFailure extends Failure {
  final String message;

  const RecordFailure({required this.message});

  @override
  List<Object> get props => [message];
}