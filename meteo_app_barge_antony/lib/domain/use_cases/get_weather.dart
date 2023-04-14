import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../foundation/error/failures.dart';
import '../entities/city_entity.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';
import 'usecase.dart';

class GetWeather implements UseCase<WeatherEntity, Params> {
  final WeatherRepository repository;

  GetWeather(this.repository);

  @override
  Future<Either<Failure, WeatherEntity>> call(Params params) async {
    return await repository.getWeather(params.city, params.day);
  }
}

class Params extends Equatable {
  final CityEntity city;
  final DateTime day;

  const Params({required this.city, required this.day});

  @override
  List<Object?> get props => [city, day];
}
