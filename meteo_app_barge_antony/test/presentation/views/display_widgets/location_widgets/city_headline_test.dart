import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:meteo_app_barge_antony/domain/managers/weather_provider.dart';
import 'package:meteo_app_barge_antony/domain/repositories/location_repository.dart';
import 'package:meteo_app_barge_antony/domain/repositories/weather_repository.dart';
import 'package:meteo_app_barge_antony/domain/states/weather_state.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_city_from_lat_long.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_current_location.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_weather.dart';
import 'package:meteo_app_barge_antony/foundation/util/input_converter.dart';
import 'package:meteo_app_barge_antony/presentation/ui/views/display_widgets/location_widgets/city_headline.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

import 'city_headline_test.mocks.dart';

@GenerateMocks([WeatherRepository])
@GenerateMocks([LocationRepository])

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late MockLocationRepository mockLocationRepository;
  late GetWeather getWeather;
  late GetCityFromLatLong getCityFromLatLong;
  late GetCurrentLocation getCurrentLocation;
  late InputConverter inputConverter;
  late WeatherProvider weatherProvider;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    mockLocationRepository = MockLocationRepository();
    getWeather = GetWeather(mockWeatherRepository);
    getCityFromLatLong = GetCityFromLatLong(mockLocationRepository);
    getCurrentLocation = GetCurrentLocation(mockLocationRepository);
    inputConverter = InputConverter();
    weatherProvider = WeatherProvider(
        getWeather: getWeather,
        getCityFromLatLong: getCityFromLatLong, 
        getCurrentLocation: getCurrentLocation,
        inputConverter: inputConverter,
        selectedDay: ValueNotifier<DateTime>(DateTime(2023, 3, 30))
      );
  });

  group('CityHeadline should render correctly', () {
    const String cityName = 'Villeurbanne';
    testWidgets('CityHeadline should render correctly with location pin if it is the first page', (WidgetTester tester) async {
      const bool isAllowingLocationChange = false;

      await tester.pumpWidget(
        const MaterialApp(
          home: CityHeadline(
            cityName: cityName,
            isAllowingLocationChange: isAllowingLocationChange,
          ),
        ),
      );

      final locationIconFinder = find.byIcon(Icons.location_on);
      final editIconFinder = find.byIcon(Icons.edit);
      final cityNameFinder = find.text(cityName);

      expect(locationIconFinder, findsOneWidget);
      expect(editIconFinder, findsNothing);
      expect(cityNameFinder, findsOneWidget);
    });

    testWidgets('CityHeadline should render correctly with edit pen if it is the second page', (WidgetTester tester) async {
      const bool isAllowingLocationChange = true;

      await tester.pumpWidget(
        const MaterialApp(
          home: CityHeadline(
            cityName: cityName,
            isAllowingLocationChange: isAllowingLocationChange,
          ),
        ),
      );

      final locationIconFinder = find.byIcon(Icons.location_on);
      final editIconFinder = find.byIcon(Icons.edit);
      final cityNameFinder = find.text(cityName);

      expect(locationIconFinder, findsNothing);
      expect(editIconFinder, findsOneWidget);
      expect(cityNameFinder, findsOneWidget);
    });

    testWidgets('CityHeadline should do nothing on tap on first page', (WidgetTester tester) async {
      const bool isAllowingLocationChange = false;

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: weatherProvider),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CityHeadline(
                cityName: cityName,
                isAllowingLocationChange: isAllowingLocationChange,
              ),
            ),
          ),
        ),
      );

      final headlineFinder = find.byType(CityHeadline);

      expect(headlineFinder, findsOneWidget);
      await tester.tap(headlineFinder);
      await tester.pump();
      expect(weatherProvider.currentWeatherState, isInstanceOf<Loaded>());
    });

    testWidgets('CityHeadline should empty weather state on tap on second page', (WidgetTester tester) async {
      const bool isAllowingLocationChange = true;

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: weatherProvider),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CityHeadline(
                cityName: cityName,
                isAllowingLocationChange: isAllowingLocationChange,
              ),
            ),
          ),
        ),
      );

      final headlineFinder = find.byType(CityHeadline);
      await tester.tap(headlineFinder);
      await tester.pump();
      expect(weatherProvider.currentWeatherState, Empty());
    });
  });
}
