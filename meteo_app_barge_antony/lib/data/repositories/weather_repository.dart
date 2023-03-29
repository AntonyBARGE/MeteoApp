import 'package:dartz/dartz.dart';

import '../../foundation/error/failures.dart';
import '../models/city.dart';
import '../models/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>>? getWeather(City city);
}