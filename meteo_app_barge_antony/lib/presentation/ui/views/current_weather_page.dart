import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/injections/injection.dart';
import '../../../domain/managers/weather_provider.dart';
import '../../../domain/states/weather_state.dart';
import '../view_models/weather_display.dart';
import 'display_widgets/loading_widget.dart';
import 'display_widgets/message_display.dart';


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
      child: Column(
        children: [
          Expanded(
            child: Consumer<WeatherProvider>(
              builder:(context, weatherProvider, child) {
                var state = weatherProvider.currentWeatherState;
                if (state is Empty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => getCurrentWeatherOnline(context));
                  return const MessageDisplay(message: 'Search your weather',);
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return WeatherDisplay(weather: state.weather, city: state.city);
                } else if (state is Error) {
                  return MessageDisplay(message: state.message);
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: const Placeholder(),
                );
              },
            )
          ),
        ],
      )
    );
  }

  Future<void> getCurrentWeatherOnline(BuildContext context) async {
    var provider = context.read<WeatherProvider>();
    provider.getCurrentCityThenCall();
  }
}