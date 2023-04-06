import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../application/config/constants.dart';
import '../../../domain/entities/city_entity.dart';
import '../../../foundation/error/exceptions.dart';
import '../../models/weather_model.dart';


abstract class WeatherAPI {
  Future<WeatherModel>? getWeather(CityEntity city, DateTime day);
}

class WeatherAPIImpl implements WeatherAPI {
  final http.Client client;

  WeatherAPIImpl({required this.client});

  Future<WeatherModel> _getWeatherFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<WeatherModel>? getWeather(CityEntity city, DateTime day) {
    final df = DateFormat('yyyy-MM-dd');
    final dayInUrl = df.format(day);
    final endDayInUrl = df.format(day.add(const Duration(days: 7)));
    String weatherAPIUrl = Constants.WEATHER_API_URL;
    weatherAPIUrl += 'latitude=${city.latitude}';
    weatherAPIUrl += '&longitude=${city.longitude}';
    weatherAPIUrl += '&start_date=$dayInUrl&end_date=$endDayInUrl&timezone=auto';
    weatherAPIUrl += '&current_weather=true';
    weatherAPIUrl += '&hourly=temperature_2m,apparent_temperature,precipitation_probability,windspeed_10m,weathercode';

    return _getWeatherFromUrl(weatherAPIUrl);
  }
}
