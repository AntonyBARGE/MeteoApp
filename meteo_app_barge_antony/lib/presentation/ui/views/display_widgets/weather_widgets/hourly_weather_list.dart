import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../application/config/constants.dart';
import '../../../../../foundation/object/hourly_weather.dart';
import '../../../view_models/weather.dart';
import 'hourly_weather_item.dart';

class HourlyWeatherList extends StatelessWidget {
  final DateTime today;
  final double contextWidth;
  final ValueNotifier<int> dayController;
  final ValueNotifier<DateTime> selectedDay;
  final PageController dayPageController;
  final ScrollController hourListController;
  final Weather weather;

  const HourlyWeatherList({ Key? key, required this.today, required this.contextWidth, required this.dayController,
  required this.selectedDay, required this.dayPageController, required this.hourListController, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('j');
    int highlightedHour = today.hour;
    final List<HourlyWeather> hourlyWeathers = weather.hourlyWeathers;
    final double itemWidth = contextWidth/7 + 15;
    final double initialScrollOffset = (highlightedHour > 2) ? itemWidth * (highlightedHour - 2) : 0;
    WidgetsBinding.instance.addPostFrameCallback((_) => hourListController.jumpTo(initialScrollOffset));


    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        int dayOffset = notification.metrics.pixels~/(Constants.HOURS_IN_A_DAY * itemWidth);
        if (dayOffset != dayController.value) {
          dayPageController.animateToPage(dayOffset, 
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate
          );
          dayController.value = dayOffset;
          selectedDay.value = today.add(Duration(days: dayController.value));
        }
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 35.0),
        child: ListView.separated(
          controller: hourListController,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: hourlyWeathers.length,
          separatorBuilder: (context, index) => const SizedBox(width: 15.0,),
          itemBuilder: (BuildContext context, int hour) { 
            return HourlyWeatherItem(
              hourText: (hour == DateTime.now().hour) ? 'Now' : df.format(DateTime(2022, 12, 31, hour, 0)).toString(),
              hourlyWeather: hourlyWeathers[hour],
              width: itemWidth - 15,
              isSelected: hour == highlightedHour,
            );
          },
        )
      )
    );
  }
}