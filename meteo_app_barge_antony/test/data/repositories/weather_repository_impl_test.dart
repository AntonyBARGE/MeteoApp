import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:meteo_app_barge_antony/data/models/weather_model.dart';
import 'package:meteo_app_barge_antony/data/repositories/weather_repository_impl.dart';
import 'package:meteo_app_barge_antony/data/resources/remote/weather_api.dart';
import 'package:meteo_app_barge_antony/domain/entities/city_entity.dart';
import 'package:meteo_app_barge_antony/domain/entities/weather_entity.dart';
import 'package:meteo_app_barge_antony/foundation/error/exceptions.dart';
import 'package:meteo_app_barge_antony/foundation/error/failures.dart';
import 'package:meteo_app_barge_antony/foundation/network/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';
import 'weather_repository_impl_test.mocks.dart';


@GenerateMocks([NetworkInfo])
@GenerateMocks([WeatherAPI])
void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherAPI mockWeatherAPI;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockWeatherAPI = MockWeatherAPI();
    mockNetworkInfo = MockNetworkInfo();
    repository = WeatherRepositoryImpl(
      weatherAPI: mockWeatherAPI,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getWeather', () {
    const tCityEntity = CityEntity(
      cityName: "Villeurbanne",
      longitude: 4.8799996,
      latitude: 45.78,
    );
    final tDay = DateTime(2023, 3, 30);
    final tWeatherModel = WeatherModel.fromJson(json.decode(fixture('weather.json')));
    final WeatherEntity tWeatherEntity = tWeatherModel;
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockWeatherAPI.getWeather(any, any)).thenAnswer((_) async => tWeatherModel);
      //act
      repository.getWeather(tCityEntity, tDay);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return data when the call to api is successful',
          () async {
        //arrange
        when(mockWeatherAPI.getWeather(any, any))
            .thenAnswer((_) async => tWeatherModel);
        //act
        final result = await repository.getWeather(tCityEntity, tDay);
        //assert
        verify(mockWeatherAPI.getWeather(tCityEntity, tDay));
        expect(result, equals(Right(tWeatherEntity)));
      });
      test(
          'should return serverfailure when the call to api is unsuccessful',
          () async {
        //arrange
        when(mockWeatherAPI.getWeather(any, any))
            .thenThrow(ServerException());
        //act
        final result = await repository.getWeather(tCityEntity, tDay);
        //assert
        verify(mockWeatherAPI.getWeather(tCityEntity, tDay));
        expect(result, equals(Left(ServerFailure())));
      });
    });
  });
}
