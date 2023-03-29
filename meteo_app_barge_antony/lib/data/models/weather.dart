import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double temperature;
  final double tempMax;
  final double tempMin;
  final int precipitationProbability;
  final double windSpeed;
  final int weatherCode;

  const Weather({
    required this.temperature,
    required this.tempMax,
    required this.tempMin,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.weatherCode,
  });

  @override
  List<Object?> get props => [temperature, tempMax, tempMin, precipitationProbability, windSpeed, weatherCode];
}
