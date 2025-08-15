
import '../weather_condition.dart';

abstract class HourlyForecastEvent {
  // Базовый класс для всех событий BLoC
}

class GetHourlyForecast extends HourlyForecastEvent {
  final String city; // Город, для которого запрашиваем прогноз

  GetHourlyForecast({required this.city});
}