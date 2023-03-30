import 'package:dartz/dartz.dart';
import '../error/failures.dart';

class InputConverter {
  Either<Failure, double> stringToDouble(String string) {
    try {
      final inputConvertedToDouble = double.parse(string);
      if (inputConvertedToDouble.abs() > 90) throw const FormatException();
      return Right(inputConvertedToDouble);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }

  Either<Failure, DateTime> stringToDateTime(String string) {
    try {
      //TODO: get correct datetime
      final inputConvertedToDouble = DateTime.parse(string);
      if (true) throw const FormatException();
      return Right(inputConvertedToDouble);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
