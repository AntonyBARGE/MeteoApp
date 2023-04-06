import 'package:flutter/material.dart';

import '../../application/config/constants.dart';
import '../../foundation/error/failures.dart';
import '../../foundation/util/input_converter.dart';
import '../entities/city_entity.dart';
import '../events/weather_event.dart';
import '../states/weather_state.dart';
import '../use_cases/get_city_from_lat_long.dart';
import '../use_cases/get_current_location.dart';
import '../use_cases/get_weather.dart';
import '../use_cases/usecase.dart';

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

  void changeWeatherFromCity(CityEntity city, DateTime date) async {
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
    final inputLatEither = inputConverter.latStringToDouble(inputs.latitudeInput);
    final inputLongEither = inputConverter.longStringToDouble(inputs.longitudeInput);
    final inputDayEither = inputConverter.stringToDateTime(inputs.dayInput);

    inputLatEither.fold(
      (failure) {
        weatherState = const Error(message: Constants.INVALID_LATITUDE_INPUT_FAILURE_MESSAGE);
        notifyListeners();
      }, 
      (verifiedLatitudeDouble) {
        inputLongEither.fold(
          (failure) {
            weatherState = const Error(message: Constants.INVALID_LONGITUDE_INPUT_FAILURE_MESSAGE);
            notifyListeners();
          }, 
          (verifiedLongitudeDouble) {
            inputDayEither.fold(
              (failure) {
                weatherState = const Error(message: Constants.INVALID_DAY_INPUT_FAILURE_MESSAGE);
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
      return Constants.INVALID_LATITUDE_INPUT_FAILURE_MESSAGE;
    case ServerFailure:
      return Constants.SERVER_FAILURE_MESSAGE;
    case LocationFailure:
      return Constants.LOCATION_FAILURE_MESSAGE;
    default:
      return Constants.NONE_FAILURE_MESSAGE;
  }
}
