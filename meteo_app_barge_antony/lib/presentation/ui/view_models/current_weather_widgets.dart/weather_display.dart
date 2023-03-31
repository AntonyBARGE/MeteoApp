import '../../../../data/models/weather.dart';
import 'package:flutter/material.dart';

class WeatherDisplay extends StatelessWidget {
  final Weather weather;
  const WeatherDisplay({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(weather.hourlyWeathers.toString(),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  weather.weatherCode.toString(),
                  style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
