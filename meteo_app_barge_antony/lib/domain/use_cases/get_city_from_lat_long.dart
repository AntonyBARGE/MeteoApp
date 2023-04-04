import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/location_repository.dart';
import '../entities/city.dart';
import '../../foundation/error/failures.dart';
import 'usecase.dart';

class GetCityFromLatLong implements UseCase<City, LocationParams> {
  final LocationRepository repository;

  GetCityFromLatLong(this.repository);

  @override
  Future<Either<Failure, City>?> call(LocationParams params) async {
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
