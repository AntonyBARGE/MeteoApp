import 'package:flutter/material.dart';

import '../../../styles/ui.dart';

class CityHeadline extends StatelessWidget {
  final String cityName;

  const CityHeadline({Key? key, required this.cityName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Colors.white, size: 24.0,),
          Text(cityName, style: UI.CITY_HEADLINE_TEXT_STYLE)
        ],
      )
    );
  }
}