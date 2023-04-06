import 'package:dartz/dartz.dart';
import 'package:meteo_app_barge_antony/data/repositories/weather_repository.dart';
import 'package:meteo_app_barge_antony/data/resources/remote/weather_api.dart';
import 'package:meteo_app_barge_antony/domain/entities/hourly_weather.dart';
import 'package:meteo_app_barge_antony/foundation/error/exceptions.dart';
import 'package:meteo_app_barge_antony/foundation/error/failures.dart';
import 'package:meteo_app_barge_antony/foundation/network/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

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
    const tCity = City(
      cityName: "Villeurbanne",
      longitude: 4.8799996,
      latitude: 45.78,
    );
    final tDay = DateTime(2023, 3, 30);
    List tHourlyTemperatures = [14.5,13.6,13.8,13.4,12.7,12.6,12.9,12.9,12.9,12.9,13.9,15.4,16.9,17.8,18.5,20.3,20.9,21.7,21.2,20.2,18.8,17.1,16.0,14.7,14.6,14.2,13.6,13.4,13.4,13.5,13.6,13.6,13.5,14.9,16.2,17.6,18.4,18.6,18.7,19.1,18.3,17.8,17.0,16.1,14.8,13.6,12.7,11.9,11.6,11.1,10.7,10.3,9.5,9.4,9.3,8.8,8.8,8.9,10.0,11.8,12.7,13.4,13.9,14.3,13.3,13.0,12.5,11.9,11.1,10.5,9.8,9.4,9.0,8.7,8.7,8.5,8.3,8.2,8.0,7.9,8.1,8.2,8.5,8.9,9.3,9.9,10.5,10.9,11.3,11.4,11.0,10.4,9.4,8.6,7.7,6.6,6.0,5.4,4.7,4.1,3.6,3.0,2.7,2.4,2.4,2.8,3.5,4.7,6.0,7.7,9.5,10.5,11.3,11.7,11.3,10.5,9.3,8.5,7.7,6.8,6.1,5.6,5.0,4.7,4.6,4.4,4.2,4.0,4.1,4.6,5.5,6.7,7.7,8.8,10.0,10.7,11.2,11.6,11.5,11.1,10.3,9.6,8.8,7.7,6.9,6.1,5.2,4.7,4.2,3.8,3.5,3.4,3.6,4.2,5.0,6.3,7.3,8.3,9.4,9.9,10.2,10.4,10.6,10.7,10.5,9.9,8.9,7.7,6.9,6.2,5.3,4.7,4.2,3.5,2.8,1.9,1.8,3.0,5.0,7.6,9.2,10.6,12.0,14.4,15.9,17.0,16.4,15.1,13.5,13.0,12.7,12.2];
    List tApparentTemperatures = [12.4,11.4,10.6,9.9,9.8,9.6,10.1,9.8,9.4,10.2,11.0,12.7,14.1,14.8,16.6,17.9,19.2,18.0,18.2,17.8,17.3,15.9,15.4,13.6,13.1,12.7,12.3,11.8,11.3,10.8,11.1,11.0,11.4,12.4,13.1,14.4,13.6,13.5,13.9,13.8,13.2,12.3,11.4,11.4,11.5,10.5,10.1,8.9,8.4,7.9,8.1,7.8,7.1,7.2,7.2,6.7,6.5,6.6,7.5,9.6,10.2,10.9,11.1,11.7,10.4,10.4,10.1,10.1,9.4,8.7,8.0,7.3,6.9,6.5,6.3,5.8,5.4,5.4,5.3,5.6,5.9,5.7,5.3,4.9,5.1,5.7,6.3,6.7,7.0,7.0,6.4,5.6,4.3,3.4,2.5,1.3,0.8,0.2,-0.4,-0.9,-1.5,-2.1,-2.7,-3.3,-3.5,-3.2,-2.6,-1.4,0.0,2.0,4.5,5.5,6.0,5.8,5.5,4.9,4.0,3.4,2.8,1.9,1.4,0.9,0.4,-0.4,-0.4,-0.5,-0.6,-0.8,-0.7,-0.1,0.7,1.8,2.8,3.7,4.8,5.4,5.8,6.0,6.0,5.9,5.4,4.7,3.8,2.7,1.8,1.1,0.3,-0.0,-0.2,-0.3,-0.4,-0.5,-0.3,0.2,0.9,2.0,3.1,4.5,5.8,6.3,6.7,6.8,7.1,7.1,6.8,6.2,5.4,4.3,3.6,3.0,2.3,1.8,1.4,0.8,0.1,-0.7,-0.8,0.4,2.2,4.6,6.7,8.9,10.6,11.6,13.3,14.6,14.1,13.3,12.1,11.7,11.3,10.7];
    List tPrecipitationProbabilities = [4,2,0,0,0,0,31,63,94,86,79,71,62,54,45,53,60,68,47,27,6,5,4,3,2,1,0,6,13,19,33,47,61,52,44,35,38,42,45,53,60,68,78,87,97,83,69,55,44,34,23,27,31,35,41,46,52,66,80,94,95,96,97,95,92,90,90,90,90,88,86,84,82,79,77,77,77,77,79,82,84,82,79,77,75,73,71,69,67,65,59,54,48,41,33,26,22,17,13,12,11,10,11,12,13,12,11,10,9,7,6,8,11,13,10,6,3,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,4,6,8,11,13,12,11,10,11,12,13,12,11,10,11,12,13,12,11,10,10,10,10,14,19,23,22,20,19,16,13,10,11,12,13,12,11,10,10,10,10,10,10,10,13,16,19,17,15,13,13,13,13,13,13,13];
    List tWindSpeeds = [15.0,15.7,18.4,20.5,17.7,18.5,16.7,17.5,18.1,15.2,17.0,16.6,17.7,19.1,13.4,14.6,9.5,15.5,10.1,7.2,4.0,3.3,2.4,4.1,6.5,9.3,10.1,12.3,14.6,18.1,16.3,17.0,12.3,13.1,15.4,12.9,20.9,23.9,25.3,27.8,25.3,26.0,26.4,20.2,10.8,9.5,6.3,8.3,9.0,8.7,5.6,5.5,5.5,4.0,3.7,4.5,4.7,6.6,8.3,6.6,9.1,8.8,9.7,8.9,12.5,9.6,9.0,5.6,5.4,4.9,5.5,6.6,6.6,7.1,8.4,10.2,10.9,9.9,9.3,7.2,6.6,8.8,12.7,17.4,18.7,18.4,18.6,19.3,20.4,21.0,20.9,20.9,20.6,20.2,19.5,18.7,18.0,17.4,16.9,17.3,17.7,19.1,20.5,22.7,24.4,25.1,25.0,24.9,24.9,24.9,24.9,24.8,25.2,24.9,24.1,23.0,21.7,21.1,20.2,19.6,18.8,18.3,17.8,20.9,20.2,19.5,19.1,18.5,18.4,18.6,19.2,20.2,20.9,21.6,22.3,23.1,23.8,24.2,23.1,21.3,19.5,19.6,19.9,20.4,20.1,19.2,18.0,16.4,14.5,12.2,11.3,10.8,10.6,11.6,13.0,14.2,13.8,12.3,11.6,11.6,11.2,11.2,10.9,11.3,11.7,11.5,10.5,9.6,8.6,7.2,5.9,5.1,4.3,3.8,3.3,2.8,2.6,3.4,4.7,6.5,6.8,6.8,6.8,13.3,13.7,13.3,12.2,10.8,9.1,8.9,9.3,9.9];
    List tHourlyWeatherCodes = [3,3,3,3,3,3,61,3,80,2,1,2,3,3,80,3,3,3,2,3,1,3,3,3,3,3,61,61,61,3,3,3,3,3,1,2,2,2,0,1,3,2,1,0,1,1,0,1,0,1,2,2,2,3,2,80,3,3,2,2,80,3,3,3,95,80,80,80,95,80,80,2,2,80,2,2,2,2,2,61,61,61,61,61,61,61,61,3,3,3,2,2,2,1,1,1,1,1,1,1,1,1,3,3,3,2,2,2,1,1,1,2,2,2,3,3,3,2,2,2,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,0,0,0,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,2,2,1,51,51,51,2,3,3];
    List<HourlyWeather> tHourlyWeathers = 
      List.generate(tHourlyTemperatures.length, 
        (hour) => HourlyWeather(
          temperature: tHourlyTemperatures[hour], 
          apparentTemperature: tApparentTemperatures[hour], 
          precipitationProbability: tPrecipitationProbabilities[hour], 
          windSpeed: tWindSpeeds[hour], 
          hourlyWeatherCode: tHourlyWeatherCodes[hour]
        )
      );
    final tWeather = Weather(
      hourlyWeathers: tHourlyWeathers, 
      weatherCode: 2
    );
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockWeatherAPI.getWeather(any, any)).thenAnswer((_) async => tWeather);
      //act
      repository.getWeather(tCity, tDay);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return data when the call to api is successful',
          () async {
        //arrange
        when(mockWeatherAPI.getWeather(any, any))
            .thenAnswer((_) async => tWeather);
        //act
        final result = await repository.getWeather(tCity, tDay);
        //assert
        verify(mockWeatherAPI.getWeather(tCity, tDay));
        expect(result, equals(Right(tWeather)));
      });
      test(
          'should return serverfailure when the call to api is unsuccessful',
          () async {
        //arrange
        when(mockWeatherAPI.getWeather(any, any))
            .thenThrow(ServerException());
        //act
        final result = await repository.getWeather(tCity, tDay);
        //assert
        verify(mockWeatherAPI.getWeather(tCity, tDay));
        expect(result, equals(Left(ServerFailure())));
      });
    });
  });
}
