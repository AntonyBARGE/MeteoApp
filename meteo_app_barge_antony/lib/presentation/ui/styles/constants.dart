import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class Constants {
  final FlexSchemeColor themeCustomColors = FlexSchemeColor.from(
    primary: const Color(0xff6b9dfc),
    secondary: const Color(0xffa1c6fd),
    tertiary: const Color(0xff272C52),
    brightness: Brightness.light,
  );

  final linearGradientBlue =  const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [Color(0xff6b9dfc), Color(0xff205cf1)],
      stops: [0.0,1.0]
  );
  
  late LinearGradient navbarLinearGradientBlue;
  late ThemeData lightTheme;
  late ThemeData darkTheme;

  final TextStyle cityTitleStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 24.0
  );

  late TextStyle temperatureStyle;
  late TextStyle dateStyle;
  late TextStyle navbarLabelStyle;
  late TextStyle hourlyTemperatureStyle;

  Constants(){
    lightTheme = FlexThemeData.light(
      colors: themeCustomColors,
      subThemesData: const FlexSubThemesData(),
    );
    darkTheme = FlexThemeData.dark(colors: themeCustomColors.toDark(30, true));

    navbarLinearGradientBlue =  LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [themeCustomColors.tertiary, themeCustomColors.primary],
      stops: const [0.0,1.0]
    );
    temperatureStyle = TextStyle(
      color: themeCustomColors.secondary,
      fontWeight: FontWeight.bold,
      fontSize: 80.0
    );
    hourlyTemperatureStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    dateStyle = TextStyle(
      color: themeCustomColors.secondary,
      fontSize: 16.0
    );
    navbarLabelStyle = TextStyle(
      color: themeCustomColors.secondary,
      fontWeight: FontWeight.bold,
      fontSize: 20.0
    );

  }
}