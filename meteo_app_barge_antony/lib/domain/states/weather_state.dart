import 'package:equatable/equatable.dart';

import '../entities/city_entity.dart';
import '../entities/weather_entity.dart';


abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class Empty extends WeatherState {}

class Loading extends WeatherState {}

class Loaded extends WeatherState {
  final WeatherEntity weather;
  final CityEntity city;

  const Loaded({required this.weather, required this.city});
}

class Error extends WeatherState {
  final String message;

  const Error({required this.message});
}
