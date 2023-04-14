import 'package:dartz/dartz.dart';
import 'package:meteo_app_barge_antony/foundation/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToDouble', () {
    test(
        'should return a double when the string represents a double (latitude or longitude)',
        () async {
      //arrange
      const str = '4.8799996';
      const maxValue = 180.0;
      //act
      final result = inputConverter.stringToDouble(str, maxValue);
      //assert
      expect(result, equals(const Right(4.8799996)));
    });

    test('should return a Failure when the string is not a number', () async {
      //arrange
      const str = 'a';
      const maxValue = 180.0;
      //act
      final result = inputConverter.stringToDouble(str, maxValue);
      //assert
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test('should return a Failure when the string is a number out of range',
        () async {
      //arrange
      const str = '-123';
      const maxValue = 90.0;
      //act
      final result = inputConverter.stringToDouble(str, maxValue);
      //assert
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });

  group('stringToDateTime', () {
    test(
        'should return a DateTime when the string represents a date',
        () async {
      //arrange
      const str = '2022-10-29'; //TODO: change datetime str from what we get in input
      //act
      final result = inputConverter.stringToDateTime(str);
      //assert
      expect(result, equals(Right(DateTime(2022, 10, 29))));
    });

    test('should return a Failure when the string is not a date', () async {
      //arrange
      const str = 'a';
      //act
      final result = inputConverter.stringToDateTime(str);
      //assert
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test('should return a Failure when the string is a date out of range (out of 2022-06-09 to two weeks after current day )',
        () async {
      //arrange
      const str = '2012-06-08';
      //act
      final result = inputConverter.stringToDateTime(str);
      //assert
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
