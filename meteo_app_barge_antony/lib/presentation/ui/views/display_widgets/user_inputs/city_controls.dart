import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../application/injections/injection.dart';
import '../../../../../domain/managers/weather_provider.dart';
import '../../../../../domain/use_cases/get_city_location.dart';
import '../../../styles/ui.dart';
import '../../../view_models/city.dart';
import 'weather_controls.dart';


class CityControls extends StatefulWidget {
  const CityControls({Key? key}) : super(key: key);

  @override
  State<CityControls> createState() => _CityControlsState();
}

class _CityControlsState extends State<CityControls> {
  final TextEditingController cityInputText = TextEditingController();
  final GetCityLocations getCityLocations = GetCityLocations(currentWeatherSL());
  List<City> citiesFromInput = [];
  late ValueNotifier<DateTime> selectedDay;

  @override
  Widget build(BuildContext context) {
    var provider = context.read<WeatherProvider>();
    selectedDay = provider.selectedDay;
    
    return Column(
      children: [
        _cityFormField(),
        const WeatherControls(),
        Expanded(
          child: citiesFromInput.isNotEmpty
              ? ListView.builder(
                padding: const EdgeInsets.all(0),
                  itemCount: citiesFromInput.length,
                  itemBuilder: (context, index) => _getCityTile(index),
                )
              : const Text(
                  'No result found',
                  style: TextStyle(fontSize: 24),
                ),
        ),
      ],
    );
  }

  Widget _cityFormField() => Padding(
    padding: const EdgeInsets.only(top: 50),
    child: TextField(
      controller: cityInputText,
      keyboardType: TextInputType.text,
      onChanged: (text) {
          _getCitiesFromInput();
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Ville, Région, ...',
      ),
    )
  );

  void _getCitiesFromInput() async {
    var inputs = await getCityLocations(Params(cityName: cityInputText.text));
    inputs?.fold(
      (failure) {
        setState(() {
          citiesFromInput = [];
        });
      }, 
      (verifiedCities) async {
        List<City> detailedCities = [];
        for (var cityEntity in verifiedCities) {
            City city = await City.asyncFromEntity(cityEntity);
            detailedCities.add(city);
          }
        setState(() {
          citiesFromInput = detailedCities;
        });
      }
    );
  }
  
  Widget _getCityTile(int index) {
    final City city = citiesFromInput[index];
    String textDisplayed = city.cityName;
    final String? postalCode = city.postalCode;
    final String? countryName = city.countryName;
    if (postalCode != null){
      textDisplayed += ', $postalCode';
    }
    if (countryName != null){
      textDisplayed += ', $countryName';
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: UI.SECONDARY_COLOR,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(index == 0 ? 15 : 0),
              bottom: Radius.circular(index == citiesFromInput.length-1 ? 15 : 0),
            ),
          ),
          child: ListTile(
            horizontalTitleGap: 0,
            onTap: () => getWeatherFromCityOnline(context, city, selectedDay.value),
            leading: const Icon(Icons.pin_drop_rounded),
            title: Text(
              textDisplayed,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ),
        const Divider(color: UI.TERTIARY_COLOR, thickness: 2.0, height: 2.0,),
      ]
    );
  }

  Future<void> getWeatherFromCityOnline(BuildContext context, City city, DateTime day) async {
    var provider = context.read<WeatherProvider>();
    provider.changeWeatherFromCity(city, day);
  }
}
