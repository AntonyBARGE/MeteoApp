import 'package:dartz/dartz.dart';
import 'package:meteo_app_barge_antony/foundation/error/exceptions.dart';

import '../../domain/entities/city.dart';
import '../../foundation/error/failures.dart';
import '../resources/remote/location_service.dart';

abstract class LocationRepository {
  Future<Either<Failure, City>>? getCurrentCity();
  Future<Either<Failure, City>>? getLocationFromCityName(String cityName);
  Future<Either<Failure, City>>? getCityFromLatLong(double latitude, double longitude);
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;

  LocationRepositoryImpl({required this.locationService});

  @override
  Future<Either<Failure, City>>? getCurrentCity() async {
    try {
      final City currentCity = await locationService.getCurrentLocationCity();
      return Right(currentCity);
    } on LocationException {
      return Left(LocationFailure());
    }
  }

  @override
  Future<Either<Failure, City>>? getLocationFromCityName(String cityName) async {
    try {
      final City currentCity = await locationService.getCityFromName(cityName);
      return Right(currentCity);
    } on LocationException {
      return Left(LocationFailure());
    }
  }

  @override
  Future<Either<Failure, City>>? getCityFromLatLong(double latitude, double longitude) async {
    try {
      final City currentCity = await locationService.getCityFromLatLong(latitude, longitude);
      return Right(currentCity);
    } on LocationException {
      return Left(LocationFailure());
    }
  }
}