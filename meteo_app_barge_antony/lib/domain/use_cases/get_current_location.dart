import 'package:dartz/dartz.dart';

import '../../data/repositories/location_repository.dart';
import '../entities/city.dart';
import '../../foundation/error/failures.dart';
import 'usecase.dart';

class GetCurrentLocation implements UseCase<City, NoParams> {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  @override
  Future<Either<Failure, City>?> call(NoParams params) async {
    return await repository.getCurrentCity();
  }
}
