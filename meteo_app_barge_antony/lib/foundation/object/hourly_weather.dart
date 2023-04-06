import 'package:equatable/equatable.dart';

class HourlyWeather extends Equatable {
  final double temperature;
  final double apparentTemperature;
  final int precipitationProbability;
  final double windSpeed;
  final int hourlyWeatherCode;

  const HourlyWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.hourlyWeatherCode,
  });

  @override
  List<Object?> get props => [temperature, apparentTemperature, precipitationProbability, windSpeed, hourlyWeatherCode];
}
