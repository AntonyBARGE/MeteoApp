import 'package:flutter/material.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_current_location.dart';

import '../../foundation/error/failures.dart';
import '../../foundation/util/input_converter.dart';
import '../entities/city.dart';
import '../states/weather_state.dart';
import '../events/weather_event.dart';
import '../use_cases/get_city_from_lat_long.dart';
import '../use_cases/get_weather.dart';
import '../use_cases/usecase.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String INTERNET_FAILURE_MESSAGE = 'Server Failure : Please verify your internet connection';
const String INVALID_LATITUDE_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be between -90° and 90°.';
const String INVALID_LONGITUDE_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be between -180° and 180°.';
const String INVALID_DAY_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The day must be in range of 2022-06-08 to two weeks after current day';
const String LOCATION_FAILURE_MESSAGE = 'Location Failure';

class WeatherProvider extends ChangeNotifier {
  final GetWeather getWeather;
  final GetCityFromLatLong getCityFromLatLong;
  final GetCurrentLocation getCurrentLocation;
  final InputConverter inputConverter;
  WeatherState weatherState = Empty();

  WeatherState get currentWeatherState => weatherState;

  WeatherProvider({
    required this.getWeather,
    required this.getCityFromLatLong,
    required this.getCurrentLocation,
    required this.inputConverter,
  });

  void changeWeatherFromCity(City city, DateTime date) async {
    final failureOrWeather = await getWeather(Params(city: city, day: date));
    failureOrWeather!.fold(
      (failure) {
        weatherState = Error(message: _mapFailureToMessage(failure));
        notifyListeners();
      }, 
      (weather) {
        weatherState = Loaded(weather: weather, city: city);
        notifyListeners();
      });
  }

  void verifyInputThenCall(GetWeatherForLatAndLon inputs) {
    weatherState = Loading();
    notifyListeners();
    final inputLatEither = inputConverter.latStringToDouble(inputs.latitudeString);
    final inputLongEither = inputConverter.longStringToDouble(inputs.longitudeString);
    final inputDayEither = inputConverter.stringToDateTime(inputs.dayString);

    inputLatEither.fold(
      (failure) {
        weatherState = const Error(message: INVALID_LATITUDE_INPUT_FAILURE_MESSAGE);
        notifyListeners();
      }, 
      (verifiedLatitudeDouble) {
        inputLongEither.fold(
          (failure) {
            weatherState = const Error(message: INVALID_LONGITUDE_INPUT_FAILURE_MESSAGE);
            notifyListeners();
          }, 
          (verifiedLongitudeDouble) {
            inputDayEither.fold(
              (failure) {
                weatherState = const Error(message: INVALID_DAY_INPUT_FAILURE_MESSAGE);
                notifyListeners();
              }, 
              (verifiedDayDateTime) {
                verifyCityThenCall(verifiedLatitudeDouble, verifiedLongitudeDouble, verifiedDayDateTime);
              }
            );
          }
        );
      }
    );
  }

  void verifyCityThenCall(double verifiedLatitudeDouble, double verifiedLongitudeDouble, DateTime verifiedDayDateTime) async {
    final failureOrCity = await getCityFromLatLong(LocationParams(latitude: verifiedLatitudeDouble, longitude: verifiedLongitudeDouble));
    failureOrCity!.fold(
      (failure) {
        weatherState = Error(message: _mapFailureToMessage(failure));
        notifyListeners();
      }, 
      (city) async {
        changeWeatherFromCity(city, verifiedDayDateTime);
      });
  }

  void getCurrentCityThenCall() async {
    weatherState = Loading();
    notifyListeners();
    final failureOrCity = await getCurrentLocation(NoParams());
    failureOrCity!.fold(
      (failure) {
        weatherState = Error(message: _mapFailureToMessage(failure));
        notifyListeners();
      }, 
      (city) async {
        changeWeatherFromCity(city, DateTime.now());
      });
  }

}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case InternetFailure:
      return INVALID_LATITUDE_INPUT_FAILURE_MESSAGE;
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case LocationFailure:
      return LOCATION_FAILURE_MESSAGE;
    default:
      return 'Unexpected error';
  }
}
