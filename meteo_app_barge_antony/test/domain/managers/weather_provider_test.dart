import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_app_barge_antony/application/config/constants.dart';
import 'package:meteo_app_barge_antony/data/models/weather_model.dart';
import 'package:meteo_app_barge_antony/domain/entities/city_entity.dart';
import 'package:meteo_app_barge_antony/domain/entities/weather_entity.dart';
import 'package:meteo_app_barge_antony/domain/events/weather_event.dart';
import 'package:meteo_app_barge_antony/domain/managers/weather_provider.dart';
import 'package:meteo_app_barge_antony/domain/repositories/weather_repository.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_city_from_lat_long.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_current_location.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_weather.dart';
import 'package:meteo_app_barge_antony/domain/states/weather_state.dart';
import 'package:meteo_app_barge_antony/foundation/error/failures.dart';
import 'package:meteo_app_barge_antony/foundation/util/input_converter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/fixture_reader.dart';
import 'weather_provider_test.mocks.dart';

@GenerateMocks([GetCityFromLatLong])
@GenerateMocks([GetCurrentLocation])
@GenerateMocks([InputConverter])
@GenerateMocks([WeatherRepository])

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late GetWeather mockGetWeather;
  late MockGetCityFromLatLong mockGetCityFromLatLong;
  late MockGetCurrentLocation mockGetCurrentLocation;
  late MockInputConverter mockInputConverter;
  late WeatherProvider weatherProvider;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    mockGetWeather = GetWeather(mockWeatherRepository);
    mockGetCityFromLatLong = MockGetCityFromLatLong();
    mockGetCurrentLocation = MockGetCurrentLocation();
    mockInputConverter = MockInputConverter();
    weatherProvider = WeatherProvider(
      getWeather: mockGetWeather,
      getCityFromLatLong: mockGetCityFromLatLong, 
      getCurrentLocation: mockGetCurrentLocation,
      inputConverter: mockInputConverter,
      selectedDay: ValueNotifier<DateTime>(DateTime(2023, 3, 30))
    );
  });

  group('changeWeatherFromCity', () {
    WeatherModel tWeatherModel = WeatherModel.fromJson(json.decode(fixture('weather.json')));
    WeatherEntity tWeatherEntity = tWeatherModel;
    const tCityEntity = CityEntity(
      cityName: "Villeurbanne",
      longitude: 4.8799996,
      latitude: 45.78,
    );
    final tDay = DateTime(2023, 3, 30);
    test('should return Loaded state when changeWeatherFromCity is successful', () async {
      // arrange
      when(mockGetWeather(Params(city: tCityEntity, day: tDay)))
          .thenAnswer((_) async => Right(tWeatherModel));

      // act
      weatherProvider.changeWeatherFromCity(tCityEntity, tDay);

      // assert
      verify(mockWeatherRepository.getWeather(tCityEntity, tDay)).called(1);

      final loadedStateCompleter = Completer();
      Future.delayed(const Duration(seconds: 2), () {
        expect(weatherProvider.currentWeatherState, Loaded(weather: tWeatherEntity, city: tCityEntity));
        loadedStateCompleter.complete();
      });

      await loadedStateCompleter.future;
    });

    test('should return Error state when changeWeatherFromCity fails', () async {
      //arrange
      when(mockGetWeather(Params(city: tCityEntity, day: tDay)))
          .thenAnswer((_) async => Left(ServerFailure()));
      //act
      weatherProvider.changeWeatherFromCity(tCityEntity, tDay);
      //assert
      final loadedStateCompleter = Completer();
      Future.delayed(const Duration(seconds: 2), () {
        expect(weatherProvider.currentWeatherState, const Error(message: Constants.SERVER_FAILURE_MESSAGE));
        loadedStateCompleter.complete();
      });

      await loadedStateCompleter.future;
    });
  });

  group('verifyInputThenCall', () {
    const tLongitudeString = '4.8799996';
    const tLatitudeString = '45.78';
    final tDayString = DateTime(2023, 3, 30).toString();
    test('should call verifyCityThenCall when verification is successful', () async {
      //arrange
      final tInputs = GetWeatherForLatAndLon(tLatitudeString, tLongitudeString, tDayString);
      when(mockInputConverter.latStringToDouble(tLatitudeString))
          .thenAnswer((_) =>  const Right(45.78));
      when(mockInputConverter.longStringToDouble(tLongitudeString))
          .thenAnswer((_) =>  const Right(4.8799996));
      when(mockInputConverter.stringToDateTime(tDayString))
          .thenAnswer((_) =>  Right(DateTime(2023, 3, 30)));

      //act
      weatherProvider.verifyInputThenCall(tInputs);
      //assert
      verify(weatherProvider.verifyCityThenCall(45.78, 4.8799996, DateTime(2023, 3, 30))).called(1);
    });

    test('should return Error state when latStringToDouble fails', () async {
      //arrange
      const tIncorrectLatitudeString = 'a';
      final tInputs = GetWeatherForLatAndLon(tIncorrectLatitudeString, tLongitudeString, tDayString);
      when(mockInputConverter.latStringToDouble(tIncorrectLatitudeString))
          .thenAnswer((_) => Left(InvalidInputFailure()));
      when(mockInputConverter.longStringToDouble(tLongitudeString))
          .thenAnswer((_) =>  const Right(4.8799996));
      when(mockInputConverter.stringToDateTime(tDayString))
          .thenAnswer((_) =>  Right(DateTime(2023, 3, 30)));
      //act
      weatherProvider.verifyInputThenCall(tInputs);
      //assert
      final loadedStateCompleter = Completer();
      Future.delayed(const Duration(seconds: 2), () {
        expect(weatherProvider.currentWeatherState, const Error(message: Constants.INVALID_LATITUDE_INPUT_FAILURE_MESSAGE));
        loadedStateCompleter.complete();
      });

      await loadedStateCompleter.future;
    });

    test('should return Error state when longStringToDouble fails', () async {
      //arrange
      const tIncorrectLongitudeString = 'a';
      final tInputs = GetWeatherForLatAndLon(tLatitudeString, tIncorrectLongitudeString, tDayString);
      when(mockInputConverter.latStringToDouble(tLatitudeString))
          .thenAnswer((_) =>  const Right(45.78));
      when(mockInputConverter.longStringToDouble(tIncorrectLongitudeString))
          .thenAnswer((_) => Left(InvalidInputFailure()));
          when(mockInputConverter.stringToDateTime(tDayString))
          .thenAnswer((_) =>  Right(DateTime(2023, 3, 30)));
      //act
      weatherProvider.verifyInputThenCall(tInputs);
      //assert
      final loadedStateCompleter = Completer();
      Future.delayed(const Duration(seconds: 2), () {
        expect(weatherProvider.currentWeatherState, const Error(message: Constants.INVALID_LONGITUDE_INPUT_FAILURE_MESSAGE));
        loadedStateCompleter.complete();
      });

      await loadedStateCompleter.future;
    });

    test('should return Error state when stringToDateTime fails', () async {
      //arrange
      const tIncorrectDayString = 'a';
      const tInputs = GetWeatherForLatAndLon(tLatitudeString, tLongitudeString, tIncorrectDayString);
      when(mockInputConverter.latStringToDouble(tLatitudeString))
          .thenAnswer((_) =>  const Right(45.78));
      when(mockInputConverter.longStringToDouble(tLongitudeString))
          .thenAnswer((_) =>  const Right(4.8799996));
      when(mockInputConverter.stringToDateTime(tIncorrectDayString))
          .thenAnswer((_) => Left(InvalidInputFailure()));
      //act
      weatherProvider.verifyInputThenCall(tInputs);
      //assert
      final loadedStateCompleter = Completer();
      Future.delayed(const Duration(seconds: 2), () {
        expect(weatherProvider.currentWeatherState, const Error(message: Constants.INVALID_DAY_INPUT_FAILURE_MESSAGE));
        loadedStateCompleter.complete();
      });

      await loadedStateCompleter.future;
    });
  });
}
