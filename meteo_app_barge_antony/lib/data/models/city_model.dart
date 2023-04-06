import '../../domain/entities/city_entity.dart';

class CityModel extends CityEntity {

  const CityModel({
    required String cityName,
    required double longitude,
    required double latitude
  }) : super(cityName: cityName, longitude: longitude, latitude: latitude);

  @override
  List<Object?> get props => [cityName, longitude, latitude];
}
