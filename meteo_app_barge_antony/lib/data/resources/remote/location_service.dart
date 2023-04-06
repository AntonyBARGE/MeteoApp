import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../foundation/error/exceptions.dart';
import '../../models/city_model.dart';


abstract class LocationService {
  Future<CityModel> getCurrentLocationCity();
  Future<CityModel> getCityFromName(String cityName);
  Future<CityModel> getCityFromLatLong(double latitude, double longitude);
}

class LocationServiceImpl implements LocationService {
  late bool serviceEnabled;
  late LocationPermission permission;

  LocationServiceImpl();

  @override
  Future<CityModel> getCurrentLocationCity() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.denied || permission != LocationPermission.deniedForever) {
          final Position currentPosition = await Geolocator.getCurrentPosition();
          final CityModel currentCity = await getCurrentCityFromPosition(currentPosition);
          return currentCity;
        }
      }
    }
    throw LocationException();
  }

  @override
  Future<CityModel> getCityFromName(String cityName) async {
    List<Location> locations;
    try {
      locations = await locationFromAddress(cityName);
    } on PlatformException  {
      throw LocationException();
    }
    var city = locations.first;
    return CityModel(
      cityName: cityName, 
      latitude: city.latitude, 
      longitude: city.longitude
    );
  }

  @override
  Future<CityModel> getCityFromLatLong(double latitude, double longitude) async {
    List<Placemark> placemarks;
    try {
      placemarks = await placemarkFromCoordinates(latitude, longitude);
    } on PlatformException  {
      throw LocationException();
    }
    String? cityName = placemarks.first.locality;
    if (cityName == null || cityName == ''){
      cityName = 'Nowhere';
    }
    return CityModel(
      cityName: cityName, 
      latitude: latitude,
      longitude: longitude
    );
  }

  Future<CityModel> getCurrentCityFromPosition(Position currentPosition) async {
    final Position position = currentPosition;
    final lat = position.latitude;
    final long = position.longitude;
    return getCityFromLatLong(lat, long);
  }
}
