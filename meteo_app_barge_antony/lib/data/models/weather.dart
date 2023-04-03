import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:meteo_app_barge_antony/domain/entities/hourly_weather.dart';

import '../../domain/entities/daily_weather.dart';

class Weather extends Equatable {
  final List<HourlyWeather> hourlyWeathers;
  final int weatherCode;

  List<DailyWeather> get dailyWeathers => getDailyWeathers();

  const Weather({
    required this.hourlyWeathers,
    required this.weatherCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<HourlyWeather> hourlyWeatherFromJSON = 
      List.generate(json['hourly']['temperature_2m'].length, 
        (hour) => HourlyWeather(
          temperature: json['hourly']['temperature_2m'][hour], 
          apparentTemperature: json['hourly']['apparent_temperature'][hour], 
          precipitationProbability: json['hourly']['precipitation_probability'][hour], 
          windSpeed: json['hourly']['windspeed_10m'][hour], 
          hourlyWeatherCode: json['hourly']['weathercode'][hour]
        )
      );
    int weatherCodeFromJSON = json['current_weather']['weathercode'];
    return Weather(hourlyWeathers: hourlyWeatherFromJSON, weatherCode: weatherCodeFromJSON);
  }

  Map<String, dynamic> toJson() {
    List hourlyTemperatures = List.generate(hourlyWeathers.length, (hour) => hourlyWeathers[hour].temperature);
    List apparentTemperatures = List.generate(hourlyWeathers.length, (hour) => hourlyWeathers[hour].apparentTemperature);
    List precipitationProbabilities = List.generate(hourlyWeathers.length, (hour) => hourlyWeathers[hour].precipitationProbability);
    List windSpeeds = List.generate(hourlyWeathers.length, (hour) => hourlyWeathers[hour].windSpeed);
    List hourlyWeatherCodes = List.generate(hourlyWeathers.length, (hour) => hourlyWeathers[hour].hourlyWeatherCode);
    return {
      'current_weather': {
        'weatherCode': weatherCode,
      },
      'hourly': {
        'temperature_2m': hourlyTemperatures,
        'apparent_temperature': apparentTemperatures,
        'precipitation_probability': precipitationProbabilities,
        'windspeed_10m': windSpeeds,
        'weathercode': hourlyWeatherCodes,
      },
    };
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
