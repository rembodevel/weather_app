// Модель данных, которая представляет один город из ответа OpenWeather API
class CityModel {
  final String name; // Название города
  final double lat; // Широта (latitude)
  final double lon; // Долгота (longitude)
  final String country; // Код страны (например, "RU")

  // Конструктор для инициализации всех полей
  CityModel({required this.name, required this.lat, required this.lon, required this.country});

  // Фабричный конструктор: создаёт объект CityModel из JSON
  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    name: json['name'],
    lat: json['lat'].toDouble(),
    lon: json['lon'].toDouble(),
    country: json['country'],
  );
}

// Используется при парсинге ответа от OpenWeather API.