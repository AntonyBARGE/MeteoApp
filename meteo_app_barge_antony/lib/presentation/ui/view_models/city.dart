import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

import '../../../domain/entities/city_entity.dart';
import '../../../foundation/error/exceptions.dart';
import '../../../foundation/util/string_extension.dart';

class City extends CityEntity {
  final String? postalCode;
  final String? countryName;

  const City({
    required String cityName,
    required double longitude,
    required double latitude,
    this.countryName,
    this.postalCode
  }) : super(cityName: cityName, longitude: longitude, latitude: latitude);

  factory City.fromEntity(CityEntity entity) {
    return City(
      cityName: entity.cityName,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  @override
  List<Object?> get props => [cityName, longitude, latitude];
  
  static Future<City> asyncFromEntity(CityEntity entity) async {
    List<Placemark> placemarks;
    try {
      placemarks = await placemarkFromCoordinates(entity.latitude, entity.longitude);
    } on PlatformException  {
      throw LocationException();
    }
    String? cityName = placemarks.first.locality;
    if (cityName == null || cityName == ''){
      cityName = 'Nowhere';
    }
    return City(
      cityName: cityName.capitalize(), 
      latitude: entity.latitude,
      longitude: entity.longitude,
      postalCode: placemarks.first.postalCode,
      countryName: placemarks.first.country
    );
  }
}
