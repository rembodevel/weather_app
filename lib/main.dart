import 'package:flutter/material.dart';
import 'package:weather_app/city_maps.dart';
import 'package:weather_app/home/bloc/home_page_bloc.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'database/weather_database.dart';
import 'home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home/bloc/home_page_state.dart';
import 'home/weather_service.dart';

void main() {
  // Создаем сервис, БД и репозиторий
  final weatherService = WeatherService();
  final weatherDatabase = WeatherDatabase();
  final repository = WeatherRepository(weatherService, weatherDatabase);
  runApp(
      BlocProvider <HomePageBloc>(
      // создали провайдер и мы можем передавать любой блок добавленный в этот провайдер в дочерный виджеты
      create: (_) => HomePageBloc(InitialState(),
          repository: repository),
        child: const MyApp(),
      ),
  ); // передаем виджет MyApp

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // build отрисовка интерфейса
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      onGenerateRoute: _onGenerateRoute,
      initialRoute: '/',
      home: HomePage(), //const MyHomePage(),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/selectCity':
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CityMaps(city: args,),
        );
    }
  }
}
