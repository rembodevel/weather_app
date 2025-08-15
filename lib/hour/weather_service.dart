import 'package:dio/dio.dart';
import 'hourly_weather_model.dart';
import 'hourly_forecast_data.dart';
// WeatherService реализует сервис для получения почасового прогноза погоды с помощью API OpenWeatherMap.
// Он делает HTTP-запрос, обрабатывает JSON-ответ и преобразует его в удобные модели для отображения в
// пользовательском интерфейсе (UI).
class WeatherService {
  final Dio _dio = Dio(); // Создаем экземпляр Dio для HTTP-запросов
  final String _apiKey =
      ''; // API ключ OpenWeatherMap

  // Метод получения прогноза с API и преобразования его в список UI моделей
  Future<List<HourlyWeatherModel>> getHourlyForecast(double lat, double lon) async {
    // Формируем URL запроса к API, подставляя координаты и ключ
    final url ='https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    final response = await _dio.get(url); // Выполняем GET запрос по сформированному URL и ждем ответ
    final List<dynamic> list = response.data['list']; // Получаем из ответа массив с данными по часам (ключ 'list')
    // Преобразуем каждый JSON объект из списка в модель HourlyWeatherModel и возвращаем список моделей
    final List<HourlyForecastData> hourlyForecastData = list.map((json) =>
        HourlyForecastData.fromJson(json)).toList();
    for (var item in hourlyForecastData) {
      print('Осадки (rainVolume): ${item.rainVolume}');
    }
    // Преобразуем список моделей HourlyForecastData в список моделей для UI - HourlyWeatherModel
    final List<HourlyWeatherModel> hourlyWeatherModels =
        hourlyForecastData.map((hourly) {
          // Берём иконку из первого погодного условия, если оно есть, иначе дефолт '01d'
          final icon = hourly.weather.isNotEmpty ? hourly.weather[0].icon : '01d';
      return HourlyWeatherModel.fromRaw(
        hourly.dateTime,
        icon,
        hourly.temperature,
        hourly.precipitationProbability,
        hourly.windSpeed,
        hourly.windDeg,
      );
    }).toList();
    //print('Ответ ${list}');
    // Возвращаем список готовых моделей для отображения в UI
    return hourlyWeatherModels;
  }

  Future<List<HourlyWeatherModel>> getHourlyForecastByCity(String city) async {
    final geoUrl = 'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$_apiKey';
    final geoResponse = await _dio.get(geoUrl);

    if (geoResponse.data != null && geoResponse.data.length > 0) {
      final double lat = geoResponse.data[0]['lat'];
      final double lon = geoResponse.data[0]['lon'];

      return await getHourlyForecast(lat, lon);
    } else {
      throw Exception('Не удалось найти координаты города: $city');
    }
  }
}
