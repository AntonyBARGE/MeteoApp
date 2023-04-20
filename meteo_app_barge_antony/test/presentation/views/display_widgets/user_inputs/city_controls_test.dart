import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:meteo_app_barge_antony/domain/managers/weather_provider.dart';
import 'package:meteo_app_barge_antony/domain/repositories/location_repository.dart';
import 'package:meteo_app_barge_antony/domain/repositories/weather_repository.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_city_from_lat_long.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_current_location.dart';
import 'package:meteo_app_barge_antony/domain/use_cases/get_weather.dart';
import 'package:meteo_app_barge_antony/foundation/util/input_converter.dart';
import 'package:meteo_app_barge_antony/presentation/ui/views/display_widgets/user_inputs/city_controls.dart';
import 'package:mockito/annotations.dart';

import '../location_widgets/city_headline_test.mocks.dart';
import 'package:meteo_app_barge_antony/application/injections/injection.dart' as injections;

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

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await injections.init();
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
    testWidgets('cityFormField should allow to enter text and find according location', (WidgetTester tester) async {
      //arange
      final cityFormFieldFinder = find.byElementType(TextField);
      final cityTileFinder = find.byElementType(ListTile);

      //act
      await tester.pumpWidget(
        const MaterialApp(
          home: CityControls(),
        ),
      );
      await tester.enterText(cityFormFieldFinder, 'Villeurbanne');

      //assert
      expect(cityFormFieldFinder, findsOneWidget);
      expect(cityTileFinder, findsOneWidget);
    });
  });
}
