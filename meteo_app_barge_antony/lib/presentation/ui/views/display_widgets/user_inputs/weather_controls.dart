import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/events/weather_event.dart';
import '../../../../../domain/managers/weather_provider.dart';
import '../../../../../foundation/util/input_converter.dart';
import '../../../styles/ui.dart';


class WeatherControls extends StatefulWidget {
  final DateTime selectedDate;
  const WeatherControls({
    Key? key, required this.selectedDate
  }) : super(key: key);

  @override
  State<WeatherControls> createState() => _WeatherControlsState();
}

class _WeatherControlsState extends State<WeatherControls> {
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  String inputLatitudeStr = '';
  String inputLongitudeStr = '';
  late DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    DateFormat df = DateFormat.yMMMMd('fr') ;
    selectedDate = widget.selectedDate;
    
    return Column(
      children: [
        const SizedBox(height: 10),
        const Divider(color: UI.SECONDARY_COLOR, thickness: 3.0,),
        const SizedBox(height: 10),
        Row(
          children: [
            _latFormField(),
            const SizedBox(width: 20),
            _longFormField(),
            _datePicker(df),
          ]
        ),
        const SizedBox(height: 10),
        _searchButton(),
        const Divider(color: UI.SECONDARY_COLOR, thickness: 3.0,),
        const SizedBox(height: 10),
      ],
    );
  }
  
  Widget _latFormField() => Expanded(
    child: TextFormField(
      controller: latitudeController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Latitude',
      ),
      onChanged: (newLatitude) {
        inputLatitudeStr = newLatitude;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a latitude';
        }
        return null;
      },
    )
  );
  
  Widget _longFormField() => Expanded(
    child: TextFormField(
      controller: longitudeController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Longitude',
      ),
      onChanged: (newLongitude) {
        inputLongitudeStr = newLongitude;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a longitude';
        }
        return null;
      },
    )
  );
  
  Widget _datePicker(DateFormat df) => Expanded(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(df.format(selectedDate), style: UI.DATE_TEXT_STYLE,),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: const Icon(Icons.calendar_month,),
          ),
        ],
      ),
    )
  );

  Future<void> _selectDate(BuildContext context) async {
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
  
  Widget _searchButton() => Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: _getWeatherOnline,
          child: const Text('Search'),
        ),
      )
    ]
  );

  void _getWeatherOnline() {
    var provider = context.read<WeatherProvider>();
    var inputs = GetWeatherForLatAndLon(inputLatitudeStr, inputLongitudeStr, selectedDate.toString());
    provider.verifyInputThenCall(inputs);
  }
}
