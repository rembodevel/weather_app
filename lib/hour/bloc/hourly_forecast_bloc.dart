
import 'package:bloc/bloc.dart';
import '../hourly_weather_model.dart';
import 'hourly_forecast_event.dart';
import 'hourly_forecast_state.dart';
import 'package:weather_app/hour/weather_service.dart';

class HourlyForecastBloc extends Bloc<HourlyForecastEvent, HourlyForecastState> {
  final WeatherService repository; // Сервис для получения данных с API

  // Конструктор блока. Указываем начальное состояние и регистрируем обработчики событий
  HourlyForecastBloc({required this.repository}) : super(InitialState()) {
    on<GetHourlyForecast>(_onGetHourlyForecast); // Реакция на событие GetHourlyForecast
  }

  // Асинхронный обработчик события GetHourlyForecast
  Future<void> _onGetHourlyForecast(
      GetHourlyForecast event, // Само событие (в нем передается город)
      Emitter<HourlyForecastState> emit, // Объект для обновления состояния
      ) async {
    emit(LoadingState()); // Показываем индикатор загрузки
    try {
      // Пытаемся получить прогноз по городу из репозитория
      final List<HourlyWeatherModel> model = await repository.getHourlyForecastByCity(event.city);
      // Если успешно, отправляем новое состояние с данными
      emit(GetHourlyWeatherSuccessState(hourlyForecast: model)); // Успех
    } catch (e) {
      // Если произошла ошибка — отправляем состояние ошибки
      emit(GetHourlyWeatherFailedState(error: e.toString())); // Ошибка
    }
  }
}