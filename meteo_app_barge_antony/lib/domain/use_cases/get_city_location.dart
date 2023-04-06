import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../foundation/error/failures.dart';
import '../entities/city_entity.dart';
import '../repositories/location_repository.dart';
import 'usecase.dart';

class GetCityLocation implements UseCase<CityEntity, Params> {
  final LocationRepository repository;

  GetCityLocation(this.repository);

  @override
  Future<Either<Failure, CityEntity>?> call(Params params) async {
    return await repository.getLocationFromCityName(params.cityName);
  }
}

class Params extends Equatable {
  final String cityName;

  const Params({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}
