
abstract class HomePageEvent{
  // родительский класс относящийся для любого Event для экрана HomePage

}
class GetCurrentWeatherEvent extends HomePageEvent {
  final String city;
  GetCurrentWeatherEvent({required this.city});
}