import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import '../../data/repositories/weather_repository.dart';
import '../../data/resources/remote/weather_api.dart';
import '../../domain/managers/weather_provider.dart';
import '../../domain/use_cases/get_weather.dart';
import '../../foundation/network/network_info.dart';
import '../../foundation/util/input_converter.dart';

// service locator
final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features -Weather
  serviceLocator.registerFactory(() => WeatherProvider(
      getWeather: serviceLocator(),
      inputConverter: serviceLocator(),
  ));

  // Use cases
  serviceLocator.registerLazySingleton(() => GetWeather(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(
            weatherAPI: serviceLocator(),
            networkInfo: serviceLocator(), 
          ));
  // Data sources
  serviceLocator.registerLazySingleton<WeatherAPI>(
      () => WeatherAPIImpl(client: serviceLocator()));

  //! Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(serviceLocator()));

  //! External
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}