import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../application/injections/injection.dart';
import '../../../../domain/managers/weather_provider.dart';
import '../display_widgets/getting_data_display_widgets/message_display.dart';
import 'weather_page.dart';


@RoutePage()
class CurrentWeatherPage extends StatelessWidget {
  const CurrentWeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => currentWeatherSL<WeatherProvider>()),
      ],
      child: buildBody(context)
    );
  }

  Widget buildBody(BuildContext context) {
    return WeatherPage(
      onEmpty: _onEmpty, 
      isAllowingLocationChange: false,
    );
  }

  Widget _onEmpty(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => getCurrentWeatherOnline(context));
    return const MessageDisplay(message: 'Search your weather',);
  }

  Future<void> getCurrentWeatherOnline(BuildContext context) async {
    var provider = context.read<WeatherProvider>();
    provider.getCurrentCityThenCall();
  }
}