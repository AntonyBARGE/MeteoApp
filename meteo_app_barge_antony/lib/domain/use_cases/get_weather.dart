import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/weather.dart';
import '../entities/city.dart';
import '../../data/repositories/weather_repository.dart';
import '../../foundation/error/failures.dart';
import 'usecase.dart';

class GetWeather implements UseCase<Weather, Params> {
  final WeatherRepository repository;

  GetWeather(this.repository);

  @override
  Future<Either<Failure, Weather>?> call(Params params) async {
    return await repository.getWeather(params.city, params.day);
  }
}

class Params extends Equatable {
  final City city;
  final DateTime day;

  const Params({required this.city, required this.day});

  @override
  List<Object?> get props => [city, day];
}
