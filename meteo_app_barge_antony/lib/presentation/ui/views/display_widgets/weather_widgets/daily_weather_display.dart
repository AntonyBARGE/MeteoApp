import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../../application/config/constants.dart';
import '../../../styles/ui.dart';
import '../../../view_models/weather.dart';
import 'bottom_sheet_weather.dart';
import 'daily_major_infos.dart';

class DailyWeatherDisplay extends StatelessWidget {
  final Weather weather;
  final PageController pageDayController;
  final ScrollController hourController;
  final DateTime today;
  final Size contextSize;

  DailyWeatherDisplay({Key? key, required this.weather, required this.pageDayController, 
  required this.hourController, required this.today, required this.contextSize}) : super(key: key);

  final ValueNotifier<DateTime> _selectedDay = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<int> _dayController = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildDailyPageView()
        ),
        Expanded(
          child: BottomSheetWeather(
            contextWidth: contextSize.width,
            weather: weather,
            today: today,
            dayController: _dayController,
            hourController: hourController, 
            pageDayController: pageDayController,
            selectedDay: _selectedDay,
          )
        )
      ]
    );
  }

  Widget _buildDailyPageView() => Stack(
    children: [
      _buildArrows(),
      _buildDailyMajorInfo()
    ]
  );

  Widget _buildArrows() => Padding(
    padding: EdgeInsets.symmetric(vertical: contextSize.height/3, horizontal: 10.0),
    child: ValueListenableBuilder<int>(
      valueListenable: _dayController,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (value != 0) ? const Icon(Icons.arrow_back_ios_rounded, color: UI.SECONDARY_COLOR,) : Container(),
            (value != weather.hourlyWeathers.length/24-1) ? const Icon(Icons.arrow_forward_ios_rounded, color: UI.SECONDARY_COLOR) : Container(),
          ],
        );
      }
    )
  );

  Widget _buildDailyMajorInfo() => PageView(
    controller: pageDayController,
    onPageChanged: (int dayIndex) {
      int hourSelected = today.hour;
      if (hourController.position.userScrollDirection == ScrollDirection.idle) {
        double itemWidth = contextSize.width/7 + 15.0;
        double scrollOffset = (Constants.HOURS_IN_A_DAY * dayIndex + hourSelected-2) * itemWidth;
        hourController.animateTo(scrollOffset, 
          duration: const Duration(milliseconds: 500), 
          curve: Curves.decelerate
        );
      }
    },
    children: _getDailyPages(),
  );

  List<Widget> _getDailyPages() {
    List<Widget> dailyDisplay = [];
    for (var dayIndex = 0; dayIndex < weather.hourlyWeathers.length/24; dayIndex++) {
      final int hourDisplayedInfos = dayIndex * 24 + today.hour;
      dailyDisplay.add(
        DailyMajorInfos(hourlyWeather: weather.hourlyWeathers[hourDisplayedInfos], screenWidth: contextSize.width,)
      );
    }
    return dailyDisplay;
  }
}