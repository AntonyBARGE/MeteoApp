// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:meteo_app_barge_antony/presentation/ui/views/pages/current_weather_page.dart'
    as _i1;
import 'package:meteo_app_barge_antony/presentation/ui/views/pages/home_page.dart'
    as _i2;
import 'package:meteo_app_barge_antony/presentation/ui/views/pages/somewhere_weather_page.dart'
    as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    CurrentWeatherRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.CurrentWeatherPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    SomewhereWeatherRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.SomewhereWeatherPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.CurrentWeatherPage]
class CurrentWeatherRoute extends _i4.PageRouteInfo<void> {
  const CurrentWeatherRoute({List<_i4.PageRouteInfo>? children})
      : super(
          CurrentWeatherRoute.name,
          initialChildren: children,
        );

  static const String name = 'CurrentWeatherRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.SomewhereWeatherPage]
class SomewhereWeatherRoute extends _i4.PageRouteInfo<void> {
  const SomewhereWeatherRoute({List<_i4.PageRouteInfo>? children})
      : super(
          SomewhereWeatherRoute.name,
          initialChildren: children,
        );

  static const String name = 'SomewhereWeatherRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}
