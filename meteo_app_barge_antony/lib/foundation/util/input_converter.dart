import 'package:dartz/dartz.dart';

import '../error/failures.dart';

final DateTime noDataBeforeThisDay = DateTime(2022, 06, 09);

class InputConverter {
  Either<Failure, double> stringToDouble(String string, double maxValue) {
    try {
      final inputConvertedToDouble = double.parse(string);
      if (inputConvertedToDouble.abs() > maxValue) throw const FormatException();
      return Right(inputConvertedToDouble);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }

  Either<Failure, double> latStringToDouble(String string) => stringToDouble(string, 90);
  Either<Failure, double> longStringToDouble(String string) => stringToDouble(string, 180);

  Either<Failure, DateTime> stringToDateTime(String string) {
    try {
      final inputConvertedToDateTime = DateTime.parse(string);
      final bool isInputConvertedToDateTimeValid = 
        !(inputConvertedToDateTime.compareTo(noDataBeforeThisDay) > 0)
        || (inputConvertedToDateTime.compareTo(DateTime.now().add(const Duration(days: 14))) > 0);

      if (isInputConvertedToDateTimeValid) throw const FormatException();
      return Right(inputConvertedToDateTime);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
