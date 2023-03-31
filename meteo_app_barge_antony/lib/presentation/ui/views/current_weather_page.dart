import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/injections/injection.dart';
import '../../../domain/managers/weather_provider.dart';
import '../../../domain/states/weather_state.dart';
import '../view_models/current_weather_widgets.dart/loading_widget.dart';
import '../view_models/current_weather_widgets.dart/message_display.dart';
import '../view_models/current_weather_widgets.dart/weather_controls.dart';
import '../view_models/current_weather_widgets.dart/weather_display.dart';

@RoutePage()
class CurrentWeatherPage extends StatelessWidget {
  const CurrentWeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => serviceLocator<WeatherProvider>()),
      ],
      child: buildBody(context)
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Consumer<WeatherProvider>(
              builder:(context, weatherProvider, child) {
                var state = weatherProvider.currentWeatherState;
                print("rebuilt : $state");
                if (state is Empty) {
                  return const MessageDisplay(message: 'Start searching');
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return WeatherDisplay(weather: state.weather);
                } else if (state is Error) {
                  return MessageDisplay(message: state.message);
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: const Placeholder(),
                );
              },
            ),
            const SizedBox(height: 20),
            const WeatherControls(),
          ],
        ),
      ),
    );
  }
}