import 'package:flutter/material.dart';

import '../../../../../foundation/object/hourly_weather.dart';
import '../../../../../foundation/util/utils.dart';
import '../../../styles/ui.dart';

class DailyMajorInfos extends StatelessWidget {
  final HourlyWeather hourlyWeather;
  final double screenWidth;

  const DailyMajorInfos({Key? key, required this.hourlyWeather, required this.screenWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = screenWidth/5;
    return Column(
      children: [
        Text('${hourlyWeather.temperature.round()}°C', style: UI.TEMPERATURE_TEXT_STYLE),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 25.0, left: horizontalPadding, right: horizontalPadding),
            child: Image.asset('assets/${getAssetFromWeatherCode(hourlyWeather.hourlyWeatherCode)}')
          )
        ),
      ]
    );
  }
}