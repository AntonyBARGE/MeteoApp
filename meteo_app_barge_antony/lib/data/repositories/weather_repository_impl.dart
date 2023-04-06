import 'package:dartz/dartz.dart';

import '../../domain/entities/city_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../foundation/error/exceptions.dart';
import '../../foundation/error/failures.dart';
import '../../foundation/network/network_info.dart';
import '../resources/remote/weather_api.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherAPI weatherAPI;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.weatherAPI,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getWeather(CityEntity city, DateTime day) async {
    if (await networkInfo.isConnected) {
      try {
        final weatherFromAPI = await weatherAPI.getWeather(city, day)!;
        return Right(weatherFromAPI);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }
}