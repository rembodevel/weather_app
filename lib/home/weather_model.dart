// Создание модели погоды
import 'dart:convert';

class WeatherModel {
  final String cityname; // название города
  final double temperature; // температура
  final String description; // описание
  final int humidity;  // Текстовое описание погоды (например, "ясно", "дождь")
  final double winSpeed; // Скорость ветра в м/с
  final int uvIndex; // Индекс ультрафиолетового излучения (пока временно задается вручную)
  final icon; // Код иконки погоды для отображения изображения

  // Конструктор класса для инициализации всех полей
  WeatherModel({
    required this.cityname,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.winSpeed,
    required this.uvIndex,
    required this.icon,
  });
  // Фабричный метод для создания экземпляра модели из JSON-объекта
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityname: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      winSpeed: json['wind']['speed'].toDouble(),
      uvIndex: 5,
      icon: json['weather'][0]['icon'],
    );
  }
  Map<String, dynamic> toMap() => {
    'cityname': cityname,
    'temperature': temperature,
    'description': description,
    'humidity': humidity,
    'winSpeed': winSpeed,
    'uvIndex': uvIndex,
    'icon': icon,
  };

  factory WeatherModel.fromMap(Map<String, dynamic> map) => WeatherModel(
    cityname: map['cityname'],
    temperature: map['temperature'],
    description: map['description'],
    humidity: map['humidity'],
    winSpeed: map['winSpeed'],
    uvIndex: map['uvIndex'],
    icon: map['icon'],
  );
}
