import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/events/weather_event.dart';
import '../../../../../domain/managers/weather_provider.dart';
import '../../../../../foundation/util/input_converter.dart';
import '../../../styles/ui.dart';


class WeatherControls extends StatefulWidget {
  const WeatherControls({
    Key? key,
  }) : super(key: key);

  @override
  State<WeatherControls> createState() => _WeatherControlsState();
}

class _WeatherControlsState extends State<WeatherControls> {
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  late String inputLatitudeStr;
  late String inputLongitudeStr;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateFormat df = DateFormat.yMMMMd('fr') ;
    
    return Column(
      children: [
        const Divider(color: UI.SECONDARY_COLOR, thickness: 3.0,),
        const SizedBox(height: 10),
        Row(
          children: [
            latFormField(),
            const SizedBox(width: 20),
            longFormField(),
            datePicker(df),
          ]
        ),
        const SizedBox(height: 10),
        searchButton(),
      ],
    );
  }
  
  Widget latFormField() => Expanded(
    child: TextField(
      controller: latitudeController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Latitude',
      ),
      onChanged: (newLatitude) {
        inputLatitudeStr = newLatitude;
      },
    )
  );
  
  Widget longFormField() => Expanded(
    child: TextField(
      controller: longitudeController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Longitude',
      ),
      onChanged: (newLongitude) {
        inputLongitudeStr = newLongitude;
      },
    )
  );
  
  Widget datePicker(DateFormat df) => Expanded(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(df.format(selectedDate)),
          ElevatedButton(
            onPressed: () => selectDate(context),
            child: const Icon(Icons.calendar_month,),
          ),
        ],
      ),
    )
  );

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: noDataBeforeThisDay,
      lastDate: DateTime.now().add(const Duration(days: 14))
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  
  Widget searchButton() => Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: getWeatherOnline,
          child: const Text('Search'),
        ),
      )
    ]
  );

  void getWeatherOnline() {
    var provider = context.read<WeatherProvider>();
    var inputs = GetWeatherForLatAndLon(inputLatitudeStr, inputLongitudeStr, selectedDate.toString());
    provider.verifyInputThenCall(inputs);
  }
}
