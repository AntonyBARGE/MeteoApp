import 'package:flutter/material.dart';

import '../../../../../foundation/object/hourly_weather.dart';
import '../../../styles/ui.dart';
import 'weather_item.dart';



class DailyRow extends StatelessWidget {
  final HourlyWeather hourlyWeather;
  
  const DailyRow({super.key, required this.hourlyWeather});

  @override
  Widget build(BuildContext context) {
    List weatherItemParams = [
      ['windspeed.png', ' km/h', hourlyWeather.windSpeed],
      ['rainshower.png', '%', hourlyWeather.precipitationProbability, UI.RAIN_PROBABILITY_TEXT_COLOR],
      ['temperature.png', '°C ressenti', hourlyWeather.apparentTemperature.round()],
    ];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(children: List.generate(3, 
        (index) => Expanded(
          child: WeatherItem(
            imageUrl: 'assets/${weatherItemParams[index][0]}',
            unit: weatherItemParams[index][1],
            value: weatherItemParams[index][2],
            textColor: weatherItemParams[index].length == 4 ? weatherItemParams[index][3] : null
          )
        )
      ))
    );
  }
}