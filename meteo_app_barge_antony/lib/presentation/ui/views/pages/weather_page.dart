import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/managers/weather_provider.dart';
import '../../../../domain/states/weather_state.dart';
import '../../view_models/city.dart';
import '../../view_models/weather.dart';
import '../display_widgets/getting_data_display_widgets/loading_widget.dart';
import '../display_widgets/getting_data_display_widgets/message_display.dart';
import '../display_widgets/weather_widgets/weather_card.dart';

class WeatherPage extends StatelessWidget {
  final Function onEmpty;
  final bool isAllowingLocationChange;
  const WeatherPage({super.key, required this.onEmpty, required this.isAllowingLocationChange});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Consumer<WeatherProvider>(
              builder:(context, weatherProvider, child) {
                var state = weatherProvider.currentWeatherState;
                if (state is Empty) {
                  return onEmpty(context);
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return WeatherCard(
                    weather: Weather.fromEntity(state.weather), 
                    city: City.fromEntity(state.city),
                    isAllowingLocationChange: isAllowingLocationChange,
                  );
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
}