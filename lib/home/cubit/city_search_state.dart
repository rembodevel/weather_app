import 'package:weather_app/home/city_model.dart';

// Абстрактное состояние, от которого наследуются все остальные
abstract class CitySearchState {}

class CitySearchInitial extends CitySearchState {
  // Начальное состояние — ничего не происходит
}

class CitySearchLoading extends CitySearchState {
  // Состояние во время загрузки данных
}

class CitySearchSuccess extends CitySearchState {
  // Состояние, когда данные успешно получены
  List<CityModel> cityModel;

  CitySearchSuccess({required this.cityModel});
}

class CitySearchError extends CitySearchState {
  // Состояние, если произошла ошибка
  String infoError;

  CitySearchError({required this.infoError});
}
