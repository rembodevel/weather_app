import 'package:intl/intl.dart';

class HourlyWeatherModel {
  final String hour ; // формат HH:00
  final String iconUrl; // URL иконки погоды
  final double temperature; // температура
  final double precipitation; // осадки (мм)
  final double windSpeed; // сила ветра (м/с)
  final String windDirection; // направление ветра (например, С, ЮЗ)
  static const directions = ['С', 'СВ', 'В', 'ЮВ', 'Ю', 'ЮЗ', 'З', 'СЗ'];


  HourlyWeatherModel(
      {required this.hour,
      required this.iconUrl,
      required this.temperature,
      required this.precipitation,
      required this.windSpeed,
      required this.windDirection});
  factory HourlyWeatherModel.fromRaw(DateTime dateTime, String icon, double temperature,
      double precipitationProbability, double windSpeed, int windDeg) {
    String hour = DateFormat.Hm().format(dateTime);
    String iconUrl = 'https://openweathermap.org/img/wn/${icon}@2x.png';
    String winDeg = directions[((windDeg + 22.5) / 45).floor() % 8];

    return HourlyWeatherModel(hour: hour, iconUrl: iconUrl,
        temperature:temperature,
        precipitation: precipitationProbability,
        windSpeed: windSpeed,
        windDirection: winDeg);
  }
}