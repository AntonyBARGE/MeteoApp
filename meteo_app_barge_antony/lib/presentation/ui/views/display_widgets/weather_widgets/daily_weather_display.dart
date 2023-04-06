import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../../application/config/constants.dart';
import '../../../styles/ui.dart';
import '../../../view_models/weather.dart';
import 'bottom_sheet_weather.dart';
import 'daily_major_infos.dart';

class DailyWeatherDisplay extends StatefulWidget {
  final Weather weather;
  final PageController pageDayController;
  final ScrollController hourController;
  final DateTime today;
  final Size contextSize;

  const DailyWeatherDisplay({Key? key, required this.weather, required this.pageDayController, 
  required this.hourController, required this.today, required this.contextSize}) : super(key: key);

  @override
  State<DailyWeatherDisplay> createState() => _DailyWeatherDisplayState();
}

class _DailyWeatherDisplayState extends State<DailyWeatherDisplay> {
  DateTime selectedDay = DateTime.now();
  int dayController = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildDailyPageView()
        ),
        Expanded(
          child: BottomSheetWeather(
            contextWidth: widget.contextSize.width,
            weather: widget.weather,
            today: widget.today,
            dayController: dayController,
            changeSelectedDate: _changeSelectedDate, 
            hourController: widget.hourController, 
            pageDayController: widget.pageDayController,
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
    padding: EdgeInsets.symmetric(vertical: widget.contextSize.height/3, horizontal: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (dayController != 0) ? const Icon(Icons.arrow_back_ios_rounded, color: UI.SECONDARY_COLOR,) : Container(),
        (dayController != widget.weather.hourlyWeathers.length/24-1) ? const Icon(Icons.arrow_forward_ios_rounded, color: UI.SECONDARY_COLOR) : Container(),
      ],
    )
  );

  Widget _buildDailyMajorInfo() => PageView(
    controller: widget.pageDayController,
    onPageChanged: (int dayIndex) {
      int hourSelected = widget.today.hour;
      if (widget.hourController.position.userScrollDirection == ScrollDirection.idle) {
        double itemWidth = widget.contextSize.width/7 + 15.0;
        double scrollOffset = (Constants.HOURS_IN_A_DAY * dayIndex + hourSelected-2) * itemWidth;
        widget.hourController.animateTo(scrollOffset, 
          duration: const Duration(milliseconds: 500), 
          curve: Curves.decelerate
        );
      }
    },
    children: _getDailyPages(),
  );

  List<Widget> _getDailyPages() {
    List<Widget> dailyDisplay = [];
    for (var dayIndex = 0; dayIndex < widget.weather.hourlyWeathers.length/24; dayIndex++) {
      final int hourDisplayedInfos = dayController * 24 + widget.today.hour;
      dailyDisplay.add(
        DailyMajorInfos(hourlyWeather: widget.weather.hourlyWeathers[hourDisplayedInfos], screenWidth: widget.contextSize.width,)
      );
    }
    return dailyDisplay;
  }

  void _changeSelectedDate(int dayOffset){
    setState(() {
      dayController = dayOffset;
      selectedDay = widget.today.add(Duration(days: dayController));
    });
  }
}