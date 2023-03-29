import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_app_barge_antony/data/models/city.dart';
import 'package:meteo_app_barge_antony/data/models/weather.dart';
import 'package:meteo_app_barge_antony/data/repositories/weather_repository.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_weather.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_weather_test.mocks.dart';

@GenerateMocks([WeatherRepository])
void main() {
  late MockWeatherRepository mockWeatherRepository;
  late GetWeather usecase;
  late City tCity;
  late Weather tWeather;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetWeather(mockWeatherRepository);
    tWeather = const Weather(
      temperature: 1.0, 
      tempMax: 1.0, 
      tempMin: 1.0, 
      precipitationProbability: 1,
      windSpeed: 1.0,
      weatherCode: 1,
    );
    tCity = const City(
      cityName: "Villeurbanne",
      longitude: 4.88,
      latitude: 45.77,
    );
  });

  test(
    'should get trivia for the number from the repository',
    () async {
      //arange

      when(mockWeatherRepository.getWeather(tCity))
          .thenAnswer((_) async => Right(tWeather));
      //act
      final result = await usecase(Params(city: tCity));
      //assert
      expect(result, equals(Right(tWeather)));
      verify(mockWeatherRepository.getWeather(tCity));
      verifyNoMoreInteractions(mockWeatherRepository);
    },
  );
}
