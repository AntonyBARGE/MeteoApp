import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String cityName;
  final double longitude;
  final double latitude;

  const City({
    required this.cityName,
    required this.longitude,
    required this.latitude
  });

  @override
  List<Object?> get props => [cityName, longitude, latitude];
}
