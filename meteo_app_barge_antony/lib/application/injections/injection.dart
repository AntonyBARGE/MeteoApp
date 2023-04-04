import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:meteo_app_barge_antony/domain/use_cases/get_city_from_lat_long.dart';

import '../../data/repositories/location_repository.dart';
import '../../data/repositories/weather_repository.dart';
import '../../data/resources/remote/location_service.dart';
import '../../data/resources/remote/weather_api.dart';
import '../../domain/managers/weather_provider.dart';
import '../../domain/use_cases/get_city_location.dart';
import '../../domain/use_cases/get_current_location.dart';
import '../../domain/use_cases/get_weather.dart';
import '../../foundation/network/network_info.dart';
import '../../foundation/util/input_converter.dart';

// service locator
final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features -Weather
  serviceLocator.registerFactory(() => WeatherProvider(
      getWeather: serviceLocator(),
      getCityFromLatLong: serviceLocator(),
      getCurrentLocation: serviceLocator(),
      inputConverter: serviceLocator(),
  ));

  // Use cases
  serviceLocator.registerLazySingleton(() => GetWeather(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetCurrentLocation(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetCityLocation(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetCityFromLatLong(serviceLocator()));

  // Repositories
  serviceLocator.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(
            weatherAPI: serviceLocator(),
            networkInfo: serviceLocator(), 
          ));
  serviceLocator.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(
            locationService: serviceLocator(),
          ));
  // Data sources
  serviceLocator.registerLazySingleton<WeatherAPI>(
      () => WeatherAPIImpl(client: serviceLocator()));
  serviceLocator.registerLazySingleton<LocationService>(
      () => LocationServiceImpl());

  //! Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(serviceLocator()));

  //! External
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}