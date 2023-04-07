import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:meteo_app_barge_antony/application/config/constants.dart';
import 'package:meteo_app_barge_antony/data/models/weather_model.dart';
import 'package:meteo_app_barge_antony/data/resources/remote/weather_api.dart';
import 'package:meteo_app_barge_antony/domain/entities/city_entity.dart';
import 'package:meteo_app_barge_antony/foundation/error/exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import 'weather_api_test.mocks.dart';


@GenerateMocks([http.Client])

void main() {
  late WeatherAPIImpl weatherAPI;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    weatherAPI = WeatherAPIImpl(client: mockHttpClient);
  });


  group('getWeather from API', () {
    const tCityEntity = CityEntity(
      cityName: "Villeurbanne",
      longitude: 4.8799996,
      latitude: 45.78,
    );
    final tDay = DateTime(2023, 3, 30);
    final df = DateFormat('yyyy-MM-dd');
    final tDayInUrl = df.format(tDay);
    final tEndDayInUrl = df.format(tDay.add(const Duration(days: 7)));
    final weatherAPIUrl = '${Constants.WEATHER_API_URL}latitude=${tCityEntity.latitude}&longitude=${tCityEntity.longitude}&start_date=$tDayInUrl&end_date=$tEndDayInUrl&timezone=auto&current_weather=true&hourly=temperature_2m,apparent_temperature,precipitation_probability,windspeed_10m,weathercode';
    final tWeatherModel = WeatherModel.fromJson(json.decode(fixture('weather.json')));

    void setUpMockHttpClientSuccess200() {
      when(mockHttpClient.get(Uri.parse(weatherAPIUrl), headers: {'Content-Type': 'application/json'}))
          .thenAnswer(
            (_) async => http.Response(fixture('weather.json'), 200),
      );
    }

    void setUpMockHttpClientFailure404() {
      when(mockHttpClient.get(Uri.parse(weatherAPIUrl), headers: {'Content-Type': 'application/json'}))
          .thenAnswer(
            (_) async => http.Response('Something went wrong', 404),
      );
    }

    test(
      'should perform a GET request on a URL with latitude, longitude, start_date and end_date as params',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        await weatherAPI.getWeather(tCityEntity, tDay);
        // assert
        verify(
          mockHttpClient.get(Uri.parse(weatherAPIUrl), headers: {'Content-Type': 'application/json'}),
        );
      },
    );

    test(
      'should return WeatherModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await weatherAPI.getWeather(tCityEntity, tDay);
        // assert
        expect(result, tWeatherModel);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = weatherAPI.getWeather;
        // assert
        expect(() => call(tCityEntity, tDay), throwsA(isA<ServerException>()));
      },
    );
  });
}
