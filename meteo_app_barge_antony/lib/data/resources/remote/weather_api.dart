import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../foundation/error/exceptions.dart';
import '../../../domain/entities/city.dart';
import '../../models/weather.dart';


abstract class WeatherAPI {
  Future<Weather>? getWeather(City city, DateTime day);
}

class WeatherAPIImpl implements WeatherAPI {
  final http.Client client;

  WeatherAPIImpl({required this.client});

  Future<Weather> _getWeatherFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Weather>? getWeather(City city, DateTime day) {
    final df = DateFormat('yyyy-mm-dd');
    final dayInUrl = df.format(day);
    final endDayInUrl = df.format(day.add(const Duration(days: 7)));
    String weatherAPIUrl = 'https://api.open-meteo.com/v1/forecast?';
    weatherAPIUrl += 'latitude=${city.latitude}';
    weatherAPIUrl += '&longitude=${city.longitude}';
    weatherAPIUrl += '&start_date=$dayInUrl&end_date=$endDayInUrl&timezone=auto';
    weatherAPIUrl += '&current_weather=true';
    weatherAPIUrl += '&hourly=temperature_2m,apparent_temperature,precipitation_probability,windspeed_10m,weathercode';

    return _getWeatherFromUrl(weatherAPIUrl);
  }
}
