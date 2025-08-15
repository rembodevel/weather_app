// Модель погодного состояния, описывающая текущие условия (ясно, дождь и т.п.)
class WeatherCondition {
  // Уникальный идентификатор погодного условия (например, 800 — ясно)
  final int id;
  // Краткое текстовое описание состояния погоды (например, 'Clear')
  final String main;
  // Подробное описание (например, 'clear sky')
  final String description;
  // Код иконки, например '01d', который можно использовать для формирования URL картинки
  final String icon;

  // Конструктор с именованными параметрами, все поля обязательны (required)
  WeatherCondition({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  // Фабричный метод для создания экземпляра класса из JSON-объекта
  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      id: json['id'], // Извлекаем ID погодного состояния
      main: json['main'], // Извлекаем краткое название
      description: json['description'], // Извлекаем подробное описание
      icon: json['icon'], // Извлекаем код иконки
    );
  }
}
// Преобразование:
// Метод fromJson — это фабричный метод (factory constructor), который позволяет создать экземпляр класса
// WeatherCondition из JSON-данных. Используется, когда ты получаешь ответ от сервера и хочешь преобразовать
// его в объект Dart.