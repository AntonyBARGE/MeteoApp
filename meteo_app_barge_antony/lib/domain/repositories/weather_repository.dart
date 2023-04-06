import 'package:dartz/dartz.dart';

import '../../foundation/error/failures.dart';
import '../entities/city_entity.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>>? getWeather(CityEntity city, DateTime day);
}