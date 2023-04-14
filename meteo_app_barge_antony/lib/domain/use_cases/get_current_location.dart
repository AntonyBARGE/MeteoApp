import 'package:dartz/dartz.dart';

import '../../foundation/error/failures.dart';
import '../entities/city_entity.dart';
import '../repositories/location_repository.dart';
import 'usecase.dart';

class GetCurrentLocation implements UseCase<CityEntity, NoParams> {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  @override
  Future<Either<Failure, CityEntity>> call(NoParams params) async {
    return await repository.getCurrentCity();
  }
}
