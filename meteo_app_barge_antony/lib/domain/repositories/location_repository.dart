import 'package:dartz/dartz.dart';

import '../../data/models/city_model.dart';
import '../../foundation/error/failures.dart';

abstract class LocationRepository {
  Future<Either<Failure, CityModel>>? getCurrentCity();
  Future<Either<Failure, CityModel>>? getLocationFromCityName(String cityName);
  Future<Either<Failure, CityModel>>? getCityFromLatLong(double latitude, double longitude);
}