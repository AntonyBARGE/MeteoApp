import 'dart:math';

import '../../../domain/entities/weather_entity.dart';
import '../../../foundation/object/daily_weather.dart';
import '../../../foundation/object/hourly_weather.dart';


class Weather extends WeatherEntity {

  const Weather({
    required List<HourlyWeather> hourlyWeathers,
    required int weatherCode,
  }) : super(hourlyWeathers: hourlyWeathers, weatherCode: weatherCode);

  factory Weather.fromEntity(WeatherEntity entity) {
    return Weather(
      hourlyWeathers: entity.hourlyWeathers,
      weatherCode: entity.weatherCode,
    );
  }

  @override
  List<Object?> get props => [hourlyWeathers, weatherCode];
  
  List<DailyWeather> getDailyWeathers() {
    List<List<HourlyWeather>> days = [];
    List<DailyWeather> dailyWeathers = [];
    int hoursPerDay = 24;
    for (var i = 0; i < hourlyWeathers.length; i += hoursPerDay) {
      days.add(hourlyWeathers.sublist(i, i+hoursPerDay > hourlyWeathers.length ? hourlyWeathers.length : i + hoursPerDay)); 
    }

    double? maxTemperature;
    double? minTemperature;
    double? maxApparentTemperature;
    double? minApparentTemperature;
    int? maxPrecipitationProbability;
    double? maxWindSpeed;
    
    for (final day in days) {
      for (final hour in day) {
        (maxTemperature == null) ? hour.temperature : max(maxTemperature, hour.temperature);
        (minTemperature == null) ? hour.temperature : min(minTemperature, hour.temperature);
        (maxApparentTemperature == null) ? hour.apparentTemperature : max(maxApparentTemperature, hour.apparentTemperature);
        (minApparentTemperature == null) ? hour.apparentTemperature : min(minApparentTemperature, hour.apparentTemperature);
        (maxPrecipitationProbability == null) ? hour.precipitationProbability : max(maxPrecipitationProbability, hour.precipitationProbability);
        (maxWindSpeed == null) ? hour.windSpeed : max(maxWindSpeed, hour.windSpeed);
      }
      dailyWeathers.add(DailyWeather(
        maxTemperature: maxTemperature!, 
        minTemperature: minTemperature!, 
        maxApparentTemperature: maxApparentTemperature!,
        minApparentTemperature: minApparentTemperature!,
        maxPrecipitationProbability: maxPrecipitationProbability!,
        maxWindSpeed: maxWindSpeed!
      ));
    }
    return dailyWeathers;
  }
}
