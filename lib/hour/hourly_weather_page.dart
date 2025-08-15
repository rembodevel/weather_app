import 'package:flutter/material.dart';
import 'package:weather_app/hour/bloc/hourly_forecast_event.dart';
import 'package:weather_app/hour/hourly_weather_model.dart';
import 'package:weather_app/tabs_widget.dart';
import 'package:weather_app/utils/colors.dart';
import 'bloc/hourly_forecast_state.dart';
import 'weather_service.dart';
import '../utils/text_styles.dart';
import 'package:weather_app/hour/bloc/hourly_forecast_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HourlyWeatherPage extends StatefulWidget {
  String city;

  HourlyWeatherPage({super.key, required this.city});

  @override
  State<HourlyWeatherPage> createState() => _HourlyWeatherPageState();
}

class _HourlyWeatherPageState extends State<HourlyWeatherPage> {
  // Создаем экземпляр сервиса для получения данных о погоде
  final _weatherService = WeatherService();
  late final HourlyForecastBloc _bloc;
  // Локальное состояние: список моделей с почасовым прогнозом,
  // которые будут отображаться в UI
  // List<HourlyWeatherModel> _hourlyWeatherList = [];

  @override
  void initState() {
    super.initState();
    _bloc = HourlyForecastBloc(repository: _weatherService); // локальное создание
    _bloc.add(GetHourlyForecast( city: widget.city));
  }

  @override
  void dispose() {
    _bloc.close(); // обязательно закрываем
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => _bloc,
    child:
    Scaffold(
      backgroundColor: AppColors.backgroundColorUI,
      appBar: AppBar(
        // Заголовок экрана — название города из параметра виджета
        title: Text(widget.city, style: AppTextStyles.headlineMediumCity),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColorUI,
      ),
      // Основной контент — список карточек с погодой на каждый час
      body: BlocConsumer <HourlyForecastBloc, HourlyForecastState> (
          listener: (context, state) {
            // do stuff here based on BlocA's state
            if(state is GetHourlyWeatherFailedState){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            // return widget here based on BlocA's state
            if(state is InitialState){
              return Container();
            }
            if(state is LoadingState){
              return Center(child: CircularProgressIndicator(),);
            }
            if(state is GetHourlyWeatherSuccessState){
              return ListView.builder(
                // Количество элементов в списке зависит от длины полученных данных
                itemCount: state.hourlyForecast.length,
                itemBuilder: (context, index) {
                  // Берем модель для текущего индекса
                  final hourlyWeatherListItem = state.hourlyForecast[index];
                  // Рендерим карточку с погодой на этот час
                  return card(hourlyWeatherListItem);
                },
              );
            }
            return Container();
          },
      ),

      // Нижняя навигационная панель
      bottomNavigationBar: TabsWidget(city: widget.city,),
    ));
  }

  // Виджет карточки с погодой для одного часа
  Widget card(HourlyWeatherModel hourlyWeatherListItem) {
    print('Картинка ${hourlyWeatherListItem.iconUrl}');
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundColorCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // Позволяет прокручивать по горизонтали, если не помещается
        child: Row(
          children: [
            // Время прогноза (например, "10:00")
            Text(hourlyWeatherListItem.hour, style: AppTextStyles.buttonText),
            const SizedBox(width: 7),
            // Иконка погоды. Сейчас локальный SVG из assets
            Image.network(
              hourlyWeatherListItem.iconUrl,
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 7),
            // Вероятность осадков (в миллиметрах)
            Text('${hourlyWeatherListItem.precipitation} мм',
                style: AppTextStyles.buttonText),
            const SizedBox(width: 7),
            // Температура воздуха (в градусах Цельсия)
            Text('${hourlyWeatherListItem.temperature}°C',
                style: AppTextStyles.buttonText),
            const SizedBox(width: 7),
            // Скорость ветра (метры в секунду)
            Text('${hourlyWeatherListItem.windSpeed} м/с',
                style: AppTextStyles.buttonText),
            const SizedBox(width: 7),
            // Направление ветра (например, "С", "ЮЗ" и т.п.)
            Text(hourlyWeatherListItem.windDirection,
                style: AppTextStyles.buttonText),
          ],
        ),
      ),
    );
  }
}
