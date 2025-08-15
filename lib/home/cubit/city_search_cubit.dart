import 'package:flutter_bloc/flutter_bloc.dart';
import '../city_model.dart';
import 'city_search_state.dart';
import 'package:dio/dio.dart';

// Cubit отвечает за логику поиска городов
class CitySearchCubit extends Cubit<CitySearchState> {
  // При создании cubit сразу задаём начальное состояние (CitySearchInitial)
  CitySearchCubit(super.initialState);

  final Dio _dio = Dio(); // Создаем экземпляр Dio для HTTP-запросов
  final String _apiKey =
      'ca6048d550c19796969a68b87e85d062'; // API ключ от OpenWeatherMap — нужно получить свой на сайте

  // Метод для поиска города по строке (например, "Moscow")
  Future<void> searchCity(String query) async {
    emit(CitySearchLoading()); // Переход в состояние загрузки
    // Формируем URL для запроса на геолокацию города
    final url =
        'http://api.openweathermap.org/geo/1.0/direct?q=$query,&limit=5&appid=$_apiKey';
    try {
      // отправлеям Get- запрос
      final response = await _dio.get(url);
      // Проверяем, что сервер вернул ответ 200 (успешно)
      if (response.statusCode == 200) {
        // OpenWeather возвращает просто список городов — без обёртки
        final List<dynamic> list = response.data;
        // Преобразуем каждый элемент JSON в объект CityModel
        List<CityModel> cities =list.map((json) => CityModel.fromJson(json)).toList();
        // Переходим в состояние успеха и передаём список городов
        emit(CitySearchSuccess(cityModel: cities));
      } else {
        // Если сервер вернул другой код — ошибка
        emit(CitySearchError(infoError: 'Ошибка сервиса: ${response.statusCode}'));
      }
    } catch (e) {
      // Если произошла ошибка (например, нет интернета)
      emit(CitySearchError(infoError: 'Ошибка полученнии данные: $e '));
    }
  }
}
