// ignore_for_file: constant_identifier_names

class Constants {
  // API endpoints
  static const String WEATHER_API_URL = 'https://api.open-meteo.com/v1/forecast?';

  // Failure Messages
  static const String SERVER_FAILURE_MESSAGE = 'Server Failure';
  static const String INTERNET_FAILURE_MESSAGE = 'Server Failure : Please verify your internet connection';
  static const String INVALID_LATITUDE_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be between -90° and 90°.';
  static const String INVALID_LONGITUDE_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be between -180° and 180°.';
  static const String INVALID_DAY_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The day must be in range of 2022-06-08 to two weeks after current day';
  static const String LOCATION_FAILURE_MESSAGE = 'Location Failure';
  static const String NONE_FAILURE_MESSAGE = 'Unexpected Failure';

  // Numbers
  static const HOURS_IN_A_DAY = 24;

  // Avoid instanciations
  const Constants._();
}