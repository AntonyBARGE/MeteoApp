import 'package:dartz/dartz.dart';
import '../error/failures.dart';

final DateTime noDataBeforeThisDay = DateTime(2022, 06, 08);

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
      //TODO: get correct datetime : out of range (out of 2022-06-08 to two weeks after current day )'
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
