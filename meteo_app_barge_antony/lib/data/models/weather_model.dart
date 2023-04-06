
import '../../domain/entities/weather_entity.dart';
import '../../foundation/object/hourly_weather.dart';

class WeatherModel extends WeatherEntity {
  
  const WeatherModel({
    required List<HourlyWeather> hourlyWeathers,
    required int weatherCode,
  }) : super(hourlyWeathers: hourlyWeathers, weatherCode: weatherCode);

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
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
    return WeatherModel(hourlyWeathers: hourlyWeatherFromJSON, weatherCode: weatherCodeFromJSON);
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
}
