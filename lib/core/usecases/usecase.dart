import 'package:equatable/equatable.dart';
import 'package:whobird_flutter/core/error/failures.dart';

// Using a placeholder for Either for now.
// In a real app, this would be from a package like dartz.
// abstract class UseCase<Type, Params> {
//   Future<Either<Failure, Type>> call(Params params);
// }

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// A class for use cases that do not take any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}