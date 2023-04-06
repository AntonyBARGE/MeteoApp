import 'package:equatable/equatable.dart';

class DailyWeather extends Equatable {
  final double maxTemperature;
  final double minTemperature;
  final double maxApparentTemperature;
  final double minApparentTemperature;
  final int maxPrecipitationProbability;
  final double maxWindSpeed;

  const DailyWeather({
    required this.maxTemperature,
    required this.minTemperature,
    required this.maxApparentTemperature,
    required this.minApparentTemperature,
    required this.maxPrecipitationProbability,
    required this.maxWindSpeed,
  });

  @override
  List<Object?> get props => [maxTemperature, minTemperature, maxApparentTemperature, 
    minApparentTemperature, maxPrecipitationProbability, maxWindSpeed];
}
