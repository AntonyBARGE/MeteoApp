import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/managers/weather_provider.dart';

class GetStartedDisplay extends StatelessWidget {
  const GetStartedDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: TextButton(
            onPressed: () => getCurrentWeatherOnline(context),
            child: const Text(
              'Get weather',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            )
          ),
        ),
      ),
    );
  }

  
  Future<void> getCurrentWeatherOnline(BuildContext context) async {
    var provider = context.read<WeatherProvider>();
    provider.getCurrentCityThenCall();
  }
}