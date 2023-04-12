import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../data/resources/remote/location_service.dart';
import '../../data/resources/remote/weather_api.dart';
import '../../domain/managers/weather_provider.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/use_cases/get_city_from_lat_long.dart';
import '../../domain/use_cases/get_city_location.dart';
import '../../domain/use_cases/get_current_location.dart';
import '../../domain/use_cases/get_weather.dart';
import '../../foundation/network/network_info.dart';
import '../../foundation/util/input_converter.dart';

// service locator
final currentWeatherSL = GetIt.instance;
final choosenWeatherSL = GetIt.asNewInstance();

Future<void> init() async {
  //! Features -Weather
  currentWeatherSL.registerFactory(() => WeatherProvider(
      getWeather: currentWeatherSL(),
      getCityFromLatLong: currentWeatherSL(),
      getCurrentLocation: currentWeatherSL(),
      inputConverter: currentWeatherSL(),
  ));
  choosenWeatherSL.registerFactory(() => WeatherProvider(
      getWeather: currentWeatherSL(),
      getCityFromLatLong: currentWeatherSL(),
      getCurrentLocation: currentWeatherSL(),
      inputConverter: currentWeatherSL(),
  ));

  // Use cases
  currentWeatherSL.registerLazySingleton(() => GetWeather(currentWeatherSL()));
  currentWeatherSL.registerLazySingleton(() => GetCurrentLocation(currentWeatherSL()));
  currentWeatherSL.registerLazySingleton(() => GetCityLocations(currentWeatherSL()));
  currentWeatherSL.registerLazySingleton(() => GetCityFromLatLong(currentWeatherSL()));

  // Repositories
  currentWeatherSL.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(
            weatherAPI: currentWeatherSL(),
            networkInfo: currentWeatherSL(), 
          ));
  currentWeatherSL.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(
            locationService: currentWeatherSL(),
          ));
  // Data sources
  currentWeatherSL.registerLazySingleton<WeatherAPI>(
      () => WeatherAPIImpl(client: currentWeatherSL()));
  currentWeatherSL.registerLazySingleton<LocationService>(
      () => LocationServiceImpl());

  //! Core
  currentWeatherSL.registerLazySingleton(() => InputConverter());
  currentWeatherSL.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(currentWeatherSL()));

  //! External
  currentWeatherSL.registerLazySingleton(() => http.Client());
  currentWeatherSL.registerLazySingleton(() => InternetConnectionChecker());
}