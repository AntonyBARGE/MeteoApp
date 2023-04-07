// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class UI {
  // Colors
  static const Color PRIMARY_COLOR = Color(0xff6b9dfc);
  static const Color SECONDARY_COLOR = Color(0xffa1c6fd);
  static const Color TERTIARY_COLOR = Color(0xff272C52);

  static const Color RAIN_PROBABILITY_TEXT_COLOR = Color(0xff59DAFF);

  // Gradients
  static const Gradient LINEAR_BLUE_GRADIENT = LinearGradient(begin: Alignment.bottomRight, end: Alignment.topLeft, colors: [PRIMARY_COLOR, Color(0xff205cf1)], stops: [0.0,1.0]);
  static const Gradient NAVBAR_LINEAR_BLUE_GRADIENT =  LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [TERTIARY_COLOR, PRIMARY_COLOR], stops: [0.0,1.0]);

  // Themes
  static final FlexSchemeColor THEME_CUSTOM_COLOR = FlexSchemeColor.from(primary: PRIMARY_COLOR, secondary: SECONDARY_COLOR, tertiary: TERTIARY_COLOR, brightness: Brightness.light,);
  static final ThemeData LIGHT_THEME = FlexThemeData.light(colors: THEME_CUSTOM_COLOR, subThemesData: const FlexSubThemesData(),);
  static final ThemeData DARK_THEME = FlexThemeData.dark(colors: THEME_CUSTOM_COLOR.toDark(30, true));

  // TextStyles
  static const TextStyle CITY_HEADLINE_TEXT_STYLE = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0);
  static const TextStyle TEMPERATURE_TEXT_STYLE = TextStyle(color: SECONDARY_COLOR, fontWeight: FontWeight.bold, fontSize: 80.0);
  static const TextStyle HOURLY_TEMPERATURE_TEXT_STYLE = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,);
  static const TextStyle DATE_TEXT_STYLE = TextStyle( color: SECONDARY_COLOR, fontSize: 16.0);
  static const TextStyle NAVBAR_LABEL_TEXT_STYLE = TextStyle(color: SECONDARY_COLOR, fontWeight: FontWeight.bold, fontSize: 20.0);
  static const TextStyle RAIN_PROBABILITY_TEXT_STYLE = TextStyle(color: RAIN_PROBABILITY_TEXT_COLOR, fontWeight: FontWeight.bold);

  // Sizes
  static const double BUTTON_HEIGHT = 50.0;
  static const double BUTTON_WIDTH = 100.0;

  // Durations
  static const Duration ANIMATION_DURATION = Duration(milliseconds: 500);

  // Avoid instanciations
  const UI._();
}