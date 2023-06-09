import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/managers/weather_provider.dart';
import '../../../styles/ui.dart';
import '../../../view_models/weather.dart';
import 'daily_row.dart';
import 'hourly_weather_list.dart';

class BottomSheetWeather extends StatelessWidget {
  final Weather weather;
  final ValueNotifier<int> dayController;
  final DateTime today;
  final double contextWidth;
  final PageController pageDayController;
  final ScrollController hourController;

  BottomSheetWeather({Key? key, required this.weather, required this.dayController, required this.today,
  required this.contextWidth, required this.hourController, required this.pageDayController}) : super(key: key);

  late ValueNotifier<DateTime> selectedDay;

  @override
  Widget build(BuildContext context) {
    var provider = context.read<WeatherProvider>();
    selectedDay = provider.selectedDay;
    
    return Container(
      decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(85),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          offset: const Offset(0.0, 0.0),
          blurRadius: 0.0,
        )
      ]
    ),
      child: Column(
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: selectedDay,
            builder: (context, date, _) {
              final int hourDisplayedInfos = dayController.value * 24 + today.hour;
              return DailyRow(hourlyWeather: weather.hourlyWeathers[hourDisplayedInfos],);
            },
          ),
          _customDivider(),
          _displayDate(),
          Expanded(
            child: HourlyWeatherList(
              contextWidth: contextWidth, 
              dayController: dayController, 
              hourListController: hourController, 
              dayPageController: pageDayController, 
              today: today, 
              weather: weather,
            )
          ),
        ]
      )
    );
  }
  
  Widget _customDivider() => Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.25),
          offset: const Offset(0.0, 3.0),
          blurRadius: 30.0,
        )
      ]
    ),
    child: Divider(
      thickness: 2.0,
      indent: 0.05 * contextWidth,
      endIndent: 0.05 * contextWidth,
      color: UI.PRIMARY_COLOR,
    )
  );
  
  Widget _displayDate() {
    DateFormat df = DateFormat.yMMMMd('fr');
    return Center(
      child: ValueListenableBuilder<DateTime>(
        valueListenable: selectedDay,
        builder: (context, date, _) {
          return Text(df.format(date).toString(), style: UI.DATE_TEXT_STYLE);
        },
      )
    );
  }
}