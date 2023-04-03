import 'package:intl/intl.dart';
import 'package:meteo_app_barge_antony/domain/entities/hourly_weather.dart';

import '../../../data/models/weather.dart';
import 'package:flutter/material.dart';

import '../../../foundation/util/utils.dart';
import '../styles/constants.dart';
import 'weather_item.dart';

class WeatherDisplay extends StatelessWidget {
  final Weather weather;
  const WeatherDisplay({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Constants constants = Constants();
    final Size size = MediaQuery.of(context).size;
    
    return weatherCard(constants,
      child: Column(
        children: [
          cityHeadline(constants.cityTitleStyle),
          hourlyMajorInfos(DateTime.now(), constants.temperatureStyle, constants.dateStyle),
          customDivider(size, constants),
          dailyBottomRow()
        ]
      )
    );
  }

  Widget weatherCard(Constants constants, {required Widget child}){
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: constants.linearGradientBlue,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: constants.lightTheme.primaryColor.withOpacity(0.5),
                  offset: const Offset(0.0, 5.0),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                )
              ]
            ),
            child: child,
          )
        )
      ]
    );
  }

  Widget cityHeadline(TextStyle cityTitleStyle){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Colors.white, size: 24.0,),
          Text('Nom de la ville',
          style: cityTitleStyle,
          )
        ],
      )
    );
  }

  Widget hourlyMajorInfos(DateTime date, TextStyle temperatureStyle, TextStyle dateStyle){
    HourlyWeather hourlyWeather = weather.hourlyWeathers[date.hour];
    DateFormat df = DateFormat.yMMMMd('fr') ;

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Image.asset('assets/${getAssetFromWeatherCode(hourlyWeather.hourlyWeatherCode)}')
            )
          ),
          Text('${hourlyWeather.temperature.round()}°C', style: temperatureStyle),
          Text(df.format(date).toString(), style: dateStyle),
        ]
      )
    );
  }

  Widget customDivider(Size size, Constants constants){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: const Offset(0.0, 5.0),
            blurRadius: 30.0,
          )
        ]
      ),
      child: Divider(
        thickness: 2.0,
        indent: 0.05 * size.width,
        endIndent: 0.05 * size.width,
        color: constants.lightTheme.primaryColorLight,
      )
    );
  }

  Widget dailyBottomRow(){
    List weatherItemParams = [
      ['windspeed.png', ' km/h', weather.hourlyWeathers.first.windSpeed],
      ['humidity.png', '%', weather.hourlyWeathers.first.precipitationProbability],
      ['temperature.png', '°C ressenti', weather.hourlyWeathers.first.apparentTemperature.round()],
    ];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(children: List.generate(3, 
        (index) => Expanded(
          child: WeatherItem(
            imageUrl: 'assets/${weatherItemParams[index].first}',
            unit: weatherItemParams[index][1],
            value: weatherItemParams[index].last,
          )
        )
      ))
    );
  }
}
