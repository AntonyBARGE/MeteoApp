import 'package:dartz/dartz.dart';

import '../../domain/repositories/location_repository.dart';
import '../../foundation/error/exceptions.dart';
import '../../foundation/error/failures.dart';
import '../models/city_model.dart';
import '../resources/remote/location_service.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;

  LocationRepositoryImpl({required this.locationService});

  @override
  Future<Either<Failure, CityModel>>? getCurrentCity() async {
    try {
      final CityModel currentCity = await locationService.getCurrentLocationCity();
      return Right(currentCity);
    } on LocationException {
      return Left(LocationFailure());
    }
  }

  @override
  Future<Either<Failure, CityModel>>? getLocationFromCityName(String cityName) async {
    try {
      final CityModel currentCity = await locationService.getCityFromName(cityName);
      return Right(currentCity);
    } on LocationException {
      return Left(LocationFailure());
    }
  }

  @override
  Future<Either<Failure, CityModel>>? getCityFromLatLong(double latitude, double longitude) async {
    try {
      final CityModel currentCity = await locationService.getCityFromLatLong(latitude, longitude);
      return Right(currentCity);
    } on LocationException {
      return Left(LocationFailure());
    }
  }
}