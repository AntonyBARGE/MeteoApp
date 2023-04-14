import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../foundation/error/failures.dart';
import '../entities/city_entity.dart';
import '../repositories/location_repository.dart';
import 'usecase.dart';

class GetCityFromLatLong implements UseCase<CityEntity, LocationParams> {
  final LocationRepository repository;

  GetCityFromLatLong(this.repository);

  @override
  Future<Either<Failure, CityEntity>> call(LocationParams params) async {
    return await repository.getCityFromLatLong(params.latitude, params.longitude);
  }
}

class LocationParams extends Equatable {
  final double latitude;
  final double longitude;

  const LocationParams({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
