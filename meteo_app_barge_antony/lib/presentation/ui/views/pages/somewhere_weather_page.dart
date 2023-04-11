import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../application/injections/injection.dart';
import '../../../../domain/managers/weather_provider.dart';
import '../display_widgets/user_inputs/city_controls.dart';
import 'weather_page.dart';

@RoutePage()
class SomewhereWeatherPage extends StatelessWidget {
  const SomewhereWeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => choosenWeatherSL<WeatherProvider>()),
      ],
      child: buildBody(context)
    );
  }

  Widget buildBody(BuildContext context) {
    return WeatherPage(onEmpty: _onEmpty, isAllowingLocationChange: true);
  }

  Widget _onEmpty(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: CityControls(parentContext: context)
  );
}