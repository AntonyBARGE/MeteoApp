
import 'package:flutter/material.dart';

import '../../../../../foundation/object/hourly_weather.dart';
import '../../../../../foundation/util/utils.dart';
import '../../../styles/ui.dart';

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
    final Color backgroundColor = isSelected ? UI.PRIMARY_COLOR : UI.TERTIARY_COLOR.withOpacity(0.7);
    
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
              Text('${hourlyWeather.precipitationProbability}%', style: UI.RAIN_PROBABILITY_TEXT_STYLE) : 
              const SizedBox(height: 10.0,),
          const SizedBox(height: 3.0,),
          Expanded(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('${hourlyWeather.temperature}°C', style: UI.HOURLY_TEMPERATURE_TEXT_STYLE,),
            )
          )
        ]
      ),
    );
  }
}