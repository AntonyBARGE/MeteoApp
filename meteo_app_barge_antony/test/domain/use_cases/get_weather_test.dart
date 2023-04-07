import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_app_barge_antony/data/models/weather_model.dart';
import 'package:meteo_app_barge_antony/domain/entities/city_entity.dart';
import 'package:meteo_app_barge_antony/domain/repositories/weather_repository.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_weather.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import '../../fixtures/fixture_reader.dart';
import 'get_weather_test.mocks.dart';

@GenerateMocks([WeatherRepository])

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late GetWeather usecase;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetWeather(mockWeatherRepository);
  });

  const tCityEntity = CityEntity(
    cityName: "Villeurbanne",
    longitude: 4.8799996,
    latitude: 45.78,
  );
  final tDay = DateTime(2023, 3, 30);
  final tWeatherModel = WeatherModel.fromJson(json.decode(fixture('weather.json')));

  test(
    'should get the city weather from the repository',
    () async {
      //arange
      when(mockWeatherRepository.getWeather(tCityEntity, tDay))
          .thenAnswer((_) async => Right(tWeatherModel));
      //act
      final result = await usecase(Params(city: tCityEntity, day: tDay));
      //assert
      expect(result, equals(Right(tWeatherModel)));
      verify(mockWeatherRepository.getWeather(tCityEntity, tDay));
      verifyNoMoreInteractions(mockWeatherRepository);
    },
  );
}
