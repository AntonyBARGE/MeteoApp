import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeatherForLatAndLon extends WeatherEvent {
  final String latitudeString;
  final String longitudeString;
  final String dayString;

  const GetWeatherForLatAndLon(this.latitudeString, this.longitudeString, this.dayString);
}
