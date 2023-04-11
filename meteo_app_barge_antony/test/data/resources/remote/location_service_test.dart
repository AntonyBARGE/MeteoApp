import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_app_barge_antony/data/models/city_model.dart';
import 'package:meteo_app_barge_antony/data/resources/remote/location_service.dart';
import 'package:meteo_app_barge_antony/foundation/error/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';

import 'geolocator_wrapper.dart';
import 'location_service_test.mocks.dart';

@GenerateMocks([GeolocatorWrapper])

void main() {
  late MockGeolocatorWrapper mockGeolocator;
  late LocationServiceImpl locationService;

  setUp(() {
    mockGeolocator = MockGeolocatorWrapper();
    locationService = LocationServiceImpl();
  });

  group('getCurrentLocationCity', () {
    test('should return CityModel', () async {
      const CityModel cityModel = CityModel(cityName: 'Villeurbanne', latitude: 45.78, longitude: 4.8799996);
      final Position position = Position(
        latitude: 45.78,
        longitude: 4.8799996,
        timestamp: DateTime(2023,03,30),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        isMocked: true
      );

      // Setup mock Geolocator
      when(mockGeolocator.isLocationServiceEnabled)
        .thenAnswer((_) async => true);

      when(mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.denied);

      when(mockGeolocator.requestPermission())
        .thenAnswer((_) async => LocationPermission.always);

      when(mockGeolocator.getCurrentPosition())
        .thenAnswer((_) async => position);

      // Perform test
      final result = await locationService.getCurrentLocationCity();
      expect(result, equals(cityModel));
    });

    test('should throw LocationException when location service is disabled', () async {
      when(mockGeolocator.isLocationServiceEnabled)
        .thenAnswer((_) async => false);

      expect(() => locationService.getCurrentLocationCity(),
        throwsA(isInstanceOf<LocationException>())
      );
    });

    test('should throw LocationException when permission is denied', () async {
      when(mockGeolocator.isLocationServiceEnabled)
        .thenAnswer((_) async => true);

      when(mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.denied);

      expect(() => locationService.getCurrentLocationCity(),
        throwsA(isInstanceOf<LocationException>())
      );
    });

    test('should throw LocationException when permission is deniedForever', () async {
      when(mockGeolocator.isLocationServiceEnabled)
        .thenAnswer((_) async => true);

      when(mockGeolocator.checkPermission())
        .thenAnswer((_) async => LocationPermission.deniedForever);

      expect(() => locationService.getCurrentLocationCity(),
        throwsA(isInstanceOf<LocationException>())
      );
    });
  });

  group('getCityFromName', () {
    test('should return CityModel', () async {
      const CityModel cityModel = CityModel(cityName: 'Villeurbanne', latitude: 45.78, longitude: 4.8799996);

      // Setup mock Geocoding
      final List<Location> locations = [Location(latitude: cityModel.latitude, longitude: cityModel.longitude, timestamp: DateTime(2023,03,30))];

      when(locationFromAddress(cityModel.cityName))
        .thenAnswer((_) async => locations);

      // Perform test
      final result = await locationService.getCitiesFromName(cityModel.cityName);
      expect(result.first, equals(cityModel));
    });

    test('should throw LocationException when platform exception caught', () async {
      const String cityName = 'Villeurbanne';

      // Setup mock Geocoding
      when(locationFromAddress(cityName))
        .thenThrow(PlatformException(code: 'TestCode'));

      // Perform test
      expect(() => locationService.getCitiesFromName(cityName),
        throwsA(isInstanceOf<LocationException>())
      );
    });
  });

  group('getCityFromLatLong', () {
    test('should return CityModel', () async {
      const CityModel cityModel = CityModel(cityName: 'Villeurbanne', latitude: 45.78, longitude: 4.8799996);

      // Setup mock Geocoding
      final List<Placemark> placemarks = [Placemark(locality: cityModel.cityName)];

      when(placemarkFromCoordinates(cityModel.latitude, cityModel.longitude))
        .thenAnswer((_) async => placemarks);

      // Perform test
      final result = await locationService.getCityFromLatLong(cityModel.latitude, cityModel.longitude);
      expect(result, equals(cityModel));
    });

    test('should set cityName to "Nowhere" when locality is null or empty', () async {
      const double latitude = 1.0;
      const double longitude = 1.0;
      const CityModel cityModel = CityModel(cityName: 'Nowhere', latitude: latitude, longitude: longitude);

      // Setup mock Geocoding
      final List<Placemark> placemarks = [Placemark(locality: null)];

      when(placemarkFromCoordinates(latitude, longitude))
        .thenAnswer((_) async => placemarks);

      // Perform test
      final result = await locationService.getCityFromLatLong(latitude, longitude);
      expect(result, equals(cityModel));
    });

    test('should throw LocationException when platform exception caught', () async {
      const double latitude = 1.0;
      const double longitude = 1.0;

      // Setup mock Geocoding
      when(placemarkFromCoordinates(latitude, longitude))
        .thenThrow(PlatformException(code: 'TestCode'));

      // Perform test
      expect(() => locationService.getCityFromLatLong(latitude, longitude),
        throwsA(isInstanceOf<LocationException>())
      );
    });
  });
}
