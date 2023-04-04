import 'package:equatable/equatable.dart';

import '../../data/models/weather.dart';
import '../entities/city.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class Empty extends WeatherState {}

class Loading extends WeatherState {}

class Loaded extends WeatherState {
  final Weather weather;
  final City city;

  const Loaded({required this.weather, required this.city});
}

class Error extends WeatherState {
  final String message;

  const Error({required this.message});
}
