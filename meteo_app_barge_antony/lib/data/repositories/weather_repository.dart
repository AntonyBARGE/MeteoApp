import 'package:dartz/dartz.dart';

import '../../foundation/error/exceptions.dart';
import '../../foundation/error/failures.dart';
import '../../foundation/network/network_info.dart';
import '../../domain/entities/city.dart';
import '../models/weather.dart';
import '../resources/remote/weather_api.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>>? getWeather(City city, DateTime day);
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherAPI weatherAPI;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.weatherAPI,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Weather>> getWeather(City city, DateTime day) async {
    if (await networkInfo.isConnected) {
      try {
        final weatherFromAPI = await weatherAPI.getWeather(city, day)!;
        return Right(weatherFromAPI);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}