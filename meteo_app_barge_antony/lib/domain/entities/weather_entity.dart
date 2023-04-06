import 'package:equatable/equatable.dart';

import '../../foundation/object/hourly_weather.dart';

class WeatherEntity extends Equatable {
  final List<HourlyWeather> hourlyWeathers;
  final int weatherCode;

  const WeatherEntity({
    required this.hourlyWeathers,
    required this.weatherCode,
  });

  @override
  List<Object?> get props => [hourlyWeathers, weatherCode];
}
