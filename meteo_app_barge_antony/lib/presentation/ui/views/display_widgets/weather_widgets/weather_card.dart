import 'package:flutter/material.dart';

import '../../../styles/ui.dart';
import '../../../view_models/city.dart';
import '../../../view_models/weather.dart';
import '../location_widgets/city_headline.dart';
import 'daily_weather_display.dart';


class WeatherCard extends StatelessWidget {
  final Weather weather;
  final City city;
  final bool isAllowingLocationChange;
  
  const WeatherCard({super.key, required this.weather, required this.city, required this.isAllowingLocationChange});

  @override
  Widget build(BuildContext context) {
    final PageController pageDayController = PageController();
    final ScrollController hourController = ScrollController();
    final Size contextSize = MediaQuery.of(context).size;
    final double topPadding = contextSize.height/10;
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      decoration: BoxDecoration(
        gradient: UI.LINEAR_BLUE_GRADIENT,
        boxShadow: [
          BoxShadow(
            color: UI.PRIMARY_COLOR.withOpacity(0.5),
            offset: const Offset(0.0, 5.0),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          )
        ]
      ),
      child: Column(
        children: [
          CityHeadline(cityName: city.cityName, isAllowingLocationChange: isAllowingLocationChange),
          Expanded(
            child: DailyWeatherDisplay(
              weather: weather,
              contextSize: contextSize,
              hourController: hourController,
              pageDayController: pageDayController,
              today: DateTime.now(),
              )
          )
        ]
      ),
    );
  }
}