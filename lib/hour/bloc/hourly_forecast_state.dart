
import 'package:weather_app/hour/hourly_weather_page.dart';

import '../hourly_weather_model.dart';

abstract class HourlyForecastState {
  // Базовый класс для состояний экрана прогноза
}

// Успешно полученные данные
class GetHourlyWeatherSuccessState extends HourlyForecastState {
  final List<HourlyWeatherModel> hourlyForecast;

  GetHourlyWeatherSuccessState({required this.hourlyForecast});
}

// Ошибка при получении данных
class GetHourlyWeatherFailedState extends HourlyForecastState {
  final String error;

  GetHourlyWeatherFailedState({required this.error});
}

// Состояние загрузки
class LoadingState extends HourlyForecastState {
}

// Начальное состояние
class InitialState extends HourlyForecastState {
}