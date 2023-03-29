import 'package:dartz/dartz.dart';
import 'package:meteo_app_barge_antony/data/models/city.dart';
import 'package:meteo_app_barge_antony/data/models/weather.dart';
import 'package:meteo_app_barge_antony/data/repositories/weather_repository.dart';
import 'package:meteo_app_barge_antony/foundation/error/failures.dart';
import 'package:mockito/mockito.dart';

/// A class which mocks [WeatherRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWeatherRepository extends Mock
    implements WeatherRepository {
  MockWeatherRepository() {
    throwOnMissingStub(this);
  }

  @override
  Future<Either<Failure, Weather>>?
      getWeather(City? city) => (super.noSuchMethod(
              Invocation.method(#getWeather, [city]))
          as Future<Either<Failure, Weather>>?);
}