import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class InternetFailure extends ServerFailure {
  @override
  List<Object?> get props => [];
}

class LocationFailure extends Failure {
  @override
  List<Object?> get props => [];
}