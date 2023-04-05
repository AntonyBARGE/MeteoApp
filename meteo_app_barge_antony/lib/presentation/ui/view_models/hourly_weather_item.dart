
import 'package:flutter/material.dart';

import '../../../domain/entities/hourly_weather.dart';
import '../../../foundation/util/utils.dart';
import '../styles/constants.dart';

class HourlyWeatherItem extends StatelessWidget {
  final String hourText;
  final HourlyWeather hourlyWeather;
  final double width;
  final bool isSelected;
  
  const HourlyWeatherItem({
    Key? key, required this.hourlyWeather, required this.hourText, required this.width, required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants constants = Constants();
    final Color backgroundColor = isSelected ? constants.themeCustomColors.primary : constants.themeCustomColors.tertiary.withOpacity(0.7);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      width: width,
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(hourText, style: const TextStyle(color: Colors.white),)
          ),
          const SizedBox(height: 15.0,),
          Expanded(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1, minHeight: 1), 
                child: Image.asset('assets/${getAssetFromWeatherCode(hourlyWeather.hourlyWeatherCode)}'),
              ),
            )
          ),
          const SizedBox(height: 2.0,),
          hourlyWeather.precipitationProbability > 30 ? 
              Text('${hourlyWeather.precipitationProbability}%', style: const TextStyle(color: Color(0xff59DAFF), fontWeight: FontWeight.bold)) : 
              const SizedBox(height: 10.0,),
          const SizedBox(height: 3.0,),
          Expanded(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('${hourlyWeather.temperature}°C', style: constants.hourlyTemperatureStyle,),
            )
          )
        ]
      ),
    );
  }
}