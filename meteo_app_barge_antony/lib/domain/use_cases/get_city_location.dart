import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/location_repository.dart';
import '../entities/city.dart';
import '../../foundation/error/failures.dart';
import 'usecase.dart';

class GetCityLocation implements UseCase<City, Params> {
  final LocationRepository repository;

  GetCityLocation(this.repository);

  @override
  Future<Either<Failure, City>?> call(Params params) async {
    return await repository.getLocationFromCityName(params.cityName);
  }
}

class Params extends Equatable {
  final String cityName;

  const Params({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}
