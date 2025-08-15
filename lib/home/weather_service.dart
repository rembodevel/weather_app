// Сервисный класс, который отправляет HTTP-запрос на сервер OpenWeatherMap,
// получает данные и возвращает объект WeatherModel.

import 'dart:convert'; // Для декодирования JSON-ответа
import 'package:http/http.dart' as http; // HTTP-клиент
import 'weather_model.dart'; // Импорт модели погоды

class WeatherService {
  final String apiKey = 'ca6048d550c19796969a68b87e85d062';  // API-ключ, полученный с сайта https://openweathermap.org

  // Базовый URL для текущей погоды по названию города
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Метод для запроса погоды по названию города
  Future<WeatherModel> fetchWeather(String city) async{
    // Создаем URL с параметрами: город, язык, единицы измерения, ключ
    // - q: название города
    // - appid: твой API-ключ
    // - units=metric: температура в градусах Цельсия
    // - lang=ru: локализация на русском
    final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric&lang=ru');
    // Отправляем GET-запрос по указанному URL
    final response  = await http.get(url);

    if(response.statusCode==200)
    {
      // Проверка статуса ответа: 200 — успешный ответ
      final data = json.decode(response.body);
      // Преобразуем Map в модели и возвращаем
      return WeatherModel.fromJson(data);
    }else{
      // Если статус ответа неуспешный - бросаем исключение
      throw Exception('Не удалось загрузить данные о погоде');
    }
  }

}