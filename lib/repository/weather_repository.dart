import 'package:weather_app/database/weather_database.dart';
import 'package:weather_app/home/weather_model.dart';
import 'package:weather_app/home/weather_service.dart';
import 'package:weather_app/repository/result.dart';
class WeatherRepository {
  final WeatherService weatherService;
  final WeatherDatabase weatherDatabase;

  WeatherRepository(this.weatherService, this.weatherDatabase);

  /// Возвращает результат: либо Success<WeatherModel>, либо Failure<WeatherModel>
  Future<Result<WeatherModel>> fetchWeather(String city) async {
    try {
      final fetchWeather = await weatherService.fetchWeather(city);
      await weatherDatabase.add(fetchWeather);
      return Success(fetchWeather);
    } catch (e) {
      final localWeather = await weatherDatabase.queryWeather(city);
      if (localWeather.isEmpty) {
        return Failure('Ошибка сети и нет данных в кэше.');
      }
      return Success(localWeather.last, false);
    }
  }
}
