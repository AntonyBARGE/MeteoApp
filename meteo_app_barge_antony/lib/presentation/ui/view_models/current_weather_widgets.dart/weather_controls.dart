import 'package:flutter/material.dart';
import 'package:meteo_app_barge_antony/domain/managers/weather_provider.dart';
import 'package:provider/provider.dart';


class WeatherControls extends StatefulWidget {
  const WeatherControls({
    Key? key,
  }) : super(key: key);

  @override
  State<WeatherControls> createState() => _WeatherControlsState();
}

class _WeatherControlsState extends State<WeatherControls> {
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  late String inputLatitudeStr;
  late String inputLongitudeStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: latitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Latitude',
                ),
                onChanged: (newLatitude) {
                  inputLatitudeStr = newLatitude;
                },
                onSubmitted:  (_) {
                  print("todo");
                },
              )
            ),
            Container(width: 20),
            Expanded(
              child: TextField(
                controller: longitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Longitude',
                ),
                onChanged: (newLongitude) {
                  inputLongitudeStr = newLongitude;
                },
                onSubmitted:  (_) {
                  print("todo");
                },
              )
            )
          ]
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: getWeatherOnline,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(width: 10),
          ],
        )
      ],
    );
  }

  void getWeatherOnline() {
    var provider = context.read<WeatherProvider>();
    var inputs = provider.getWeatherForLatAndLon;
    String lat = inputs.latitudeString;
    String long = inputs.longitudeString;
    String day = inputs.dayString;
    provider.verifyInputThenCall(lat, long, day);
  }
}
