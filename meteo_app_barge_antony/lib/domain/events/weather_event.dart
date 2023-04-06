import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeatherForLatAndLon extends WeatherEvent {
  final String latitudeInput;
  final String longitudeInput;
  final String dayInput;

  const GetWeatherForLatAndLon(this.latitudeInput, this.longitudeInput, this.dayInput);
}
