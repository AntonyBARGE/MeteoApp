import 'package:flutter/material.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_weather.dart';

import '../../foundation/error/failures.dart';
import '../../foundation/util/input_converter.dart';
import '../entities/city.dart';
import '../states/weather_state.dart';
import '../events/weather_event.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_LATITUDE_OR_LONGITUDE_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be between -90° and 90°.';
const String INVALID_DAY_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The day must be in range of 2022-06-08 to two weeks after current day';

class WeatherProvider extends ChangeNotifier {
  final GetWeatherForLatAndLon getWeatherForLatAndLon = 
      GetWeatherForLatAndLon('45.78', '4.8799996', DateTime(2023,03,17).toString());
  final GetWeather getWeather;
  final InputConverter inputConverter;
  WeatherState weatherState = Empty();

  WeatherState get currentWeatherState => weatherState;

  WeatherProvider({
    required this.getWeather,
    required this.inputConverter,
  }) {
    verifyInputThenCall(
      getWeatherForLatAndLon.latitudeString, 
      getWeatherForLatAndLon.longitudeString, 
      getWeatherForLatAndLon.dayString
    );
  }

  void verifyInputThenCall(String inputLat, String inputLong, String inputDay) {
    final inputLatEither = inputConverter.stringToDouble(inputLat);
    final inputLongEither = inputConverter.stringToDouble(inputLong);
    final inputDayEither = inputConverter.stringToDateTime(inputDay);

    inputLatEither.fold(
      (failure) {
        weatherState = const Error(message: INVALID_LATITUDE_OR_LONGITUDE_INPUT_FAILURE_MESSAGE);
        print("notify Listener");
        notifyListeners();
      }, 
      (verifiedLatitudeDouble) {
        inputLongEither.fold(
          (failure) {
            weatherState = const Error(message: INVALID_LATITUDE_OR_LONGITUDE_INPUT_FAILURE_MESSAGE);
            print("notify Listener");
        notifyListeners();
          }, 
          (verifiedLongitudeDouble) {
            inputDayEither.fold(
              (failure) {
                weatherState = const Error(message: INVALID_DAY_INPUT_FAILURE_MESSAGE);
                print("notify Listener");
        notifyListeners();
              }, 
              (verifiedDayDateTime) {
                weatherState = Loading();
                print("notify Listener");
        notifyListeners();
                changeWeather(verifiedLatitudeDouble, verifiedLongitudeDouble, verifiedDayDateTime);
              }
            );
          }
        );
      }
    );
  }

  void changeWeather(double verifiedLatitudeDouble, double verifiedLongitudeDouble, DateTime verifiedDayDateTime) async {
    City currentPosition = City(
      cityName: 'jetrouvelaville', //TODO: get city
      latitude: verifiedLatitudeDouble,
      longitude: verifiedLongitudeDouble,
    );
    final failureOrWeather = await getWeather(Params(city: currentPosition, day: verifiedDayDateTime));
    failureOrWeather!.fold(
      (failure) {
        weatherState = Error(message: _mapFailureToMessage(failure));
        print("notify Listener");
        notifyListeners();
      }, 
      (weather) {
        weatherState = Loaded(weather: weather);
        print("notify Listener");
        notifyListeners();
      });
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    default:
      return 'Unexpected error';
  }
}
