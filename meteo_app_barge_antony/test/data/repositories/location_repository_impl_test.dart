import 'package:dartz/dartz.dart';
import 'package:meteo_app_barge_antony/data/models/city_model.dart';
import 'package:meteo_app_barge_antony/data/repositories/location_repository_impl.dart';
import 'package:meteo_app_barge_antony/data/resources/remote/location_service.dart';
import 'package:meteo_app_barge_antony/domain/entities/city_entity.dart';
import 'package:meteo_app_barge_antony/foundation/error/exceptions.dart';
import 'package:meteo_app_barge_antony/foundation/error/failures.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'location_repository_impl_test.mocks.dart';



@GenerateMocks([LocationService])
void main() {
  late LocationRepositoryImpl repository;
  late MockLocationService locationService;

  setUp(() {
    locationService = MockLocationService();
    repository = LocationRepositoryImpl(locationService: locationService);
  });

  group('getCurrentCity', () {
    const tCityModel = CityModel(
      cityName: "Villeurbanne",
      longitude: 4.8799996,
      latitude: 45.78,
    );
    const CityEntity tCityEntity = tCityModel;

    test('should return current city from LocationService', () async {
      // arrange
      when(locationService.getCurrentLocationCity()).thenAnswer((_) async => tCityModel);

      // act
      final result = await repository.getCurrentCity();

      // assert
      expect(result, const Right(tCityEntity));
      verify(locationService.getCurrentLocationCity());
    });

    test('should return LocationFailure when LocationException is thrown', () async {
      // arrange
      when(locationService.getCurrentLocationCity()).thenThrow(LocationException());

      // act
      final result = await repository.getCurrentCity();

      // assert
      expect(result, Left(LocationFailure()));
      verify(locationService.getCurrentLocationCity());
    });
  });

  group('getLocationsFromCityName', () {
    const tCityModel = CityModel(
      cityName: "Villeurbanne",
      longitude: 4.8799996,
      latitude: 45.78,
    );
    const tCityName = 'Villeurbanne';
    final tCitiesList = [tCityModel];

    test('should return list of cities from LocationService', () async {
      // arrange
      when(locationService.getCitiesFromName(tCityName)).thenAnswer((_) async => tCitiesList);

      // act
      final result = await repository.getLocationsFromCityName(tCityName);

      // assert
      expect(result, Right(tCitiesList));
      verify(locationService.getCitiesFromName(tCityName));
    });

    test('should return LocationFailure when exception is thrown', () async {
      // arrange
      when(locationService.getCitiesFromName(tCityName)).thenThrow(Exception());

      // act
      final result = await repository.getLocationsFromCityName(tCityName);

      // assert
      expect(result, Left(LocationFailure()));
      verify(locationService.getCitiesFromName(tCityName));
    });
  });

  group('getCityFromLatLong', () {
    const tLongitude = 4.8799996;
    const tLatitude = 45.78;
    const tCityModel = CityModel(cityName: 'Villeurbanne', latitude: tLatitude, longitude: tLongitude);

    test('should return city from LocationService', () async {
      // arrange
      when(locationService.getCityFromLatLong(tLatitude, tLongitude)).thenAnswer((_) async => tCityModel);

      // act
      final result = await repository.getCityFromLatLong(tLatitude, tLongitude);

      // assert
      expect(result, const Right(tCityModel));
      verify(locationService.getCityFromLatLong(tLatitude, tLongitude));
    });

    test('should return LocationFailure when LocationException is thrown', () async {
      // arrange
      when(locationService.getCityFromLatLong(tLatitude, tLongitude)).thenThrow(LocationException());

      // act
      final result = await repository.getCityFromLatLong(tLatitude, tLongitude);

      // assert
      expect(result, Left(LocationFailure()));
      verify(locationService.getCityFromLatLong(tLatitude, tLongitude));
    });
  });
}
