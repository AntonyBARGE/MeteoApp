import '../../../domain/entities/city_entity.dart';

class City extends CityEntity {

  const City({
    required String cityName,
    required double longitude,
    required double latitude
  }) : super(cityName: cityName, longitude: longitude, latitude: latitude);

  factory City.fromEntity(CityEntity entity) {
    return City(
      cityName: entity.cityName,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  @override
  List<Object?> get props => [cityName, longitude, latitude];
}
