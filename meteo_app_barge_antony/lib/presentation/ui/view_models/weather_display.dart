import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:meteo_app_barge_antony/domain/entities/hourly_weather.dart';
import 'package:meteo_app_barge_antony/presentation/ui/view_models/hourly_weather_item.dart';

import '../../../data/models/weather.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/city.dart';
import '../../../foundation/util/utils.dart';
import '../styles/constants.dart';
import 'weather_item.dart';

class WeatherDisplay extends StatefulWidget {
  final Weather weather;
  final City city;
  const WeatherDisplay({Key? key, required this.weather, required this.city}) : super(key: key);

  @override
  State<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  DateTime selectedDay = DateTime.now();
  DateTime today = DateTime.now();
  final PageController _dayController = PageController(initialPage: 0);
  int dayController = 0;
  late ScrollController listController;

  @override
  Widget build(BuildContext context) {
    final Constants constants = Constants();
    final Size size = MediaQuery.of(context).size;
    int index = today.hour + dayController * 24;
    
    
    return weatherCard(constants, size.height,
      child: Column(
        children: [
          cityHeadline(constants.cityTitleStyle),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height/3, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (dayController != 0) ? Icon(Icons.arrow_back_ios_rounded, color: constants.themeCustomColors.secondary,) : Container(),
                      (dayController != widget.weather.hourlyWeathers.length/24-1) ? Icon(Icons.arrow_forward_ios_rounded, color: constants.themeCustomColors.secondary) : Container(),
                    ],
                  )
                ),
                PageView(
                  controller: _dayController,
                  onPageChanged: (int page) {
                    int hourSelected = today.hour;
                    if (listController.position.userScrollDirection == ScrollDirection.idle) {
                      listController.animateTo((24*page + hourSelected-2)*(size.width/7 + 15.0), 
                        duration: const Duration(milliseconds: 500), 
                        curve: Curves.decelerate
                      );
                    }
                  },
                  children: dailyPages(constants, size),
                )
              ]
            )
          ),
          Expanded(
            child: bottomSheet(constants, size, index)
          ),
        ]
      )
    );
  }

  List<Widget> dailyPages(Constants constants, Size size){
    List<Widget> dailyDisplay = [];
    for (var dayIndex = 0; dayIndex < widget.weather.hourlyWeathers.length/24; dayIndex++) {
      int index = today.hour + dayIndex * 24;
      dailyDisplay.add(
        dailyMajorInfos(constants, size.width, index)
      );
    }
    return dailyDisplay;
  }

  void changeSelectedDate(DateTime newDate){
    setState(() {
      selectedDay = newDate;
    });
  }

  Widget weatherCard(Constants constants, double screenHeight, {required Widget child}){
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: screenHeight/10),
            decoration: BoxDecoration(
              gradient: constants.linearGradientBlue,
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
          Text(widget.city.cityName,
          style: cityTitleStyle,
          )
        ],
      )
    );
  }

  Widget dailyMajorInfos(Constants constants, double screenWidth, int index){
    HourlyWeather hourlyWeather = widget.weather.hourlyWeathers[index];
    return Column(
      children: [
        Text('${hourlyWeather.temperature.round()}°C', style: constants.temperatureStyle),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: screenWidth/5),
            child: Image.asset('assets/${getAssetFromWeatherCode(hourlyWeather.hourlyWeatherCode)}')
          )
        ),
      ]
    );
  }

  Widget bottomSheet(Constants constants, Size size, int index) {
    DateFormat df = DateFormat.yMMMMd('fr') ;

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
          dailyRow(index),
          customDivider(size, constants),
          Center(
            child: Text(df.format(selectedDay).toString(), style: constants.dateStyle),
          ),
          Expanded(
            child: hourlyWeatherList(size.width/7)
          ),
        ]
      )
    );
  }

  Widget dailyRow(int index){
    List weatherItemParams = [
      ['windspeed.png', ' km/h', widget.weather.hourlyWeathers[index].windSpeed],
      ['rainshower.png', '%', widget.weather.hourlyWeathers[index].precipitationProbability, const Color(0xff59DAFF)],
      ['temperature.png', '°C ressenti', widget.weather.hourlyWeathers[index].apparentTemperature.round()],
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

  Widget customDivider(Size size, Constants constants){
    return Container(
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
        indent: 0.05 * size.width,
        endIndent: 0.05 * size.width,
        color: constants.lightTheme.primaryColorLight,
      )
    );
  }

  Widget hourlyWeatherList(double width){
    final df = DateFormat('j');
    int hourSelected = selectedDay.hour;
    final double initialScrollOffset = (hourSelected > 2) ? (width + 15) * (hourSelected - 2) : 0;
    listController = ScrollController(initialScrollOffset: initialScrollOffset);

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        int dayOffset = notification.metrics.pixels~/(24*(width + 15));
        if (dayOffset != dayController) {
          dayController = dayOffset;
          _dayController.animateToPage(dayOffset, 
            duration: const Duration(milliseconds: 500), 
            curve: Curves.decelerate
          );
          changeSelectedDate(today.add(Duration(days: dayController)));
        }
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 35.0),
        child: ListView.separated(
          controller: listController,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.weather.hourlyWeathers.length,
          separatorBuilder: (context, index) => const SizedBox(width: 15.0,),
          itemBuilder: (BuildContext context, int hour) { 
            return HourlyWeatherItem(
              hourText: (hour == selectedDay.hour) ? 'Now' : df.format(DateTime(2022, 12, 31, hour, 0)).toString(),
              hourlyWeather: widget.weather.hourlyWeathers[hour],
              width: width,
              isSelected: hour == hourSelected,
            );
          },
        )
      )
    );
  }
}
