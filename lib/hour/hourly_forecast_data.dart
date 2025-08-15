  // Импортируем модель погодного состояния, которая используется внутри этого класса
  import 'package:weather_app/hour/weather_condition.dart';
  // HourlyForecastData — это модель, представляющая почасовой прогноз погоды из ответа API forecast
  // Модель данных, описывающая почасовой прогноз погоды
  class HourlyForecastData {

    final DateTime dateTime; // Дата и время прогноза
    final double temperature; // Температура воздуха (°C)
    final double feelsLike; // Ощущаемая температура (°C)
    final int pressure; // Атмосферное давление (гПа)
    final int humidity; // Влажность воздуха (%)
    final List<WeatherCondition> weather; // Список погодных состояний (например, дождь, ясно и т.п.)
    final double windSpeed; // Скорость ветра (м/с)
    final int windDeg; // Направление ветра (в градусах)
    final double? rainVolume; // Объем осадков за 3 часа (мм). Может быть null, если осадков не было
    final double precipitationProbability; // Вероятность осадков (от 0 до 1)


    HourlyForecastData({ // Конструктор с именованными параметрами
      required this.dateTime,
      required this.temperature,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.weather,
      required this.windSpeed,
      required this.windDeg,
      required this.rainVolume,
      required this.precipitationProbability,
    });

    // Фабричный метод для создания объекта из JSON-ответа API
    factory HourlyForecastData.fromJson(Map<String, dynamic> json) {
      return HourlyForecastData(
        // Преобразуем строку даты во встроенный тип DateTime
        dateTime: DateTime.parse(json['dt_txt']),
        // Температура (может быть int или double, поэтому приводим через as num). Потом toDouble
        temperature: (json['main']['temp'] as num).toDouble(),
        // Ощущаемая температура
        feelsLike: (json['main']['feels_like'] as num).toDouble(),
        // Давление воздуха
        pressure: json['main']['pressure'],
        // Влажность воздуха
        humidity: json['main']['humidity'],
        // Преобразуем список погодных условий в список объектов WeatherCondition
        weather: (json['weather'] as List)
            .map((w) => WeatherCondition.fromJson(w))
            .toList(),
        // Скорость ветра
        windSpeed: (json['wind']['speed'] as num).toDouble(),
        // Направление ветра
        windDeg: json['wind']['deg'],
        // Объем осадков за 3 часа — если поле rain или rain['3h'] отсутствует, вернем null
        rainVolume: json['rain'] != null && json['rain']['3h'] != null
            ? (json['rain']['3h'] as num).toDouble()
            : null,
        // Вероятность осадков
        precipitationProbability: (json['pop'] as num).toDouble(),
      );
    }
  }