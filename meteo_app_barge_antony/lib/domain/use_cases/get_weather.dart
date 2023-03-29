import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/city.dart';
import '../../data/models/weather.dart';
import '../../data/repositories/weather_repository.dart';
import '../../foundation/error/failures.dart';
import 'usecase.dart';

class GetWeather implements UseCase<Weather, Params> {
  final WeatherRepository repository;

  GetWeather(this.repository);

  @override
  Future<Either<Failure, Weather>?> call(Params params) async {
    return await repository.getWeather(params.city);
  }
}

class Params extends Equatable {
  final City city;

  const Params({required this.city});

  @override
  List<Object?> get props => [city];
}
