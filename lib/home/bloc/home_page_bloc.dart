import 'package:weather_app/database/weather_database.dart';
import 'package:weather_app/home/bloc/home_page_event.dart';
import 'package:weather_app/home/bloc/home_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:weather_app/home/weather_service.dart';
import 'package:weather_app/repository/weather_repository.dart';

import '../../repository/result.dart';

// Сам блог
class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  //final WeatherRepository repository = WeatherRepository(WeatherService(), WeatherDatabase.db);
  final WeatherRepository repository;
  HomePageBloc(super.initialState, {required this.repository}){on<GetCurrentWeatherEvent>(_onGetCurrentWearther);}

  Future<void> _onGetCurrentWearther(
      GetCurrentWeatherEvent homePageEvent, Emitter<HomePageState> emit) async {
    emit(LoadingState());

    final result = await repository.fetchWeather(homePageEvent.city);
    // try {
    //   final modelWeather = await repository.fetchWeather(homePageEvent.city);
    //   emit(GetCurrentWeatherSuccessState(weatherModel: modelWeather ));
    // } catch (e) {
    //   final error = e.toString();
    //   emit(GetCurrentWeatherFailedState(infoError: error));
    // }
    switch (result) {
      case Success(:final data):
        emit(GetCurrentWeatherSuccessState(weatherModel: data));
        break;

      case Failure(:final message):
        emit(GetCurrentWeatherFailedState(infoError: message));
        break;
    }
  }
}