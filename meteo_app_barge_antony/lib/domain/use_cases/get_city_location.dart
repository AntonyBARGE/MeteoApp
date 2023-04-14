import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../foundation/error/failures.dart';
import '../entities/city_entity.dart';
import '../repositories/location_repository.dart';
import 'usecase.dart';

class GetCityLocations implements UseCase<List<CityEntity>, Params> {
  final LocationRepository repository;

  GetCityLocations(this.repository);

  @override
  Future<Either<Failure, List<CityEntity>>> call(Params params) async {
    return await repository.getLocationsFromCityName(params.cityName);
  }
}

class Params extends Equatable {
  final String cityName;

  const Params({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}
