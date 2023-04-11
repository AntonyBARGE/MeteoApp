import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/managers/weather_provider.dart';
import '../../../styles/ui.dart';

class CityHeadline extends StatelessWidget {
  final String cityName;
  final bool isAllowingLocationChange;

  const CityHeadline({Key? key, required this.cityName, required this.isAllowingLocationChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          if (isAllowingLocationChange) {
            _emptyWeatherState(context);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !isAllowingLocationChange ? 
                const Icon(Icons.location_on, color: Colors.white, size: 24.0,)
                : Container(),
            Text(cityName, style: UI.CITY_HEADLINE_TEXT_STYLE),
            isAllowingLocationChange ? 
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.edit, color: Colors.white, size: 24.0,)
                )
                : Container(),
          ],
        )
      )
    );
  }

  void _emptyWeatherState(BuildContext context) {
    var provider = context.read<WeatherProvider>();
    provider.setToEmpty();
  }
}