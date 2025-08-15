import 'package:weather_app/home/weather_model.dart';

abstract class HomePageState {}

class GetCurrentWeatherSuccessState extends HomePageState {
  // Успешный ответ
  final WeatherModel weatherModel;

  GetCurrentWeatherSuccessState({required this.weatherModel});
}

class GetCurrentWeatherFailedState extends HomePageState {
  // Не успешный ответ (Информация об ошибки)
  String infoError;

  GetCurrentWeatherFailedState({required this.infoError});
}

class LoadingState extends HomePageState {
  // Состояние загрузки
}

class InitialState extends HomePageState {
  // Исходное состояние
}

