import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/home/bloc/home_page_bloc.dart';
import 'package:weather_app/home/bloc/home_page_state.dart';
import 'package:weather_app/home/weather_model.dart';
import 'package:weather_app/home/weather_service.dart';
import 'package:weather_app/tabs_widget.dart';
import 'package:weather_app/utils/text_styles.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/strings.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home_page_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController =
  TextEditingController(); // Контроллер для поля поиска
  final WeatherService _weatherService =
  WeatherService(); // Сервис для получения данных о погоде
  late HomePageBloc homePageBloc;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunchAndLoadCity();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      // чтобы контролировать поведение при попытке выйти с экрана
      canPop: false, // Отключаем обычное поведение назад
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          // Это главный экран - выходим
          SystemNavigator.pop();
        }
      },
      child:
      BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (state is GetCurrentWeatherSuccessState) {
              return Scaffold(
                backgroundColor: AppColors.backgroundColorUI,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 44,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: searchBar(),
                    ),
                    // Обязательно оборачиваем в Expanded, чтобы ListView работал корректно
                    Expanded(
                      child: BlocConsumer<HomePageBloc, HomePageState>(
                        listener: (context, state) {
                          if (state is GetCurrentWeatherFailedState) {
                            Future.microtask(() {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: Text('Ошибка подключения'),
                                      content: Text(
                                          'Не удалось получить данные о погоде.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('ОК'),
                                        ),
                                      ],
                                    ),
                              );
                            });
                          }
                        },
                        builder: (context, state) {
                          if (state is LoadingState) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is GetCurrentWeatherSuccessState) {
                            return weather(state.weatherModel);
                          }
                          return emptyWeatherCard();
                        },
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: TabsWidget(
                  city: state.weatherModel
                      .cityname, // передаём текущий город из состояния
                ),
              );
            }
            return Scaffold(
              backgroundColor: AppColors.backgroundColorUI,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 44,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: searchBar(),
                  ),
                  // Обязательно оборачиваем в Expanded, чтобы ListView работал корректно
                  Expanded(
                    child: BlocConsumer<HomePageBloc, HomePageState>(
                      listener: (context, state) {
                        if (state is GetCurrentWeatherFailedState) {
                          Future.microtask(() {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    title: Text('Ошибка подключения'),
                                    content: Text(
                                        'Не удалось получить данные о погоде.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('ОК'),
                                      ),
                                    ],
                                  ),
                            );
                          });
                        }
                      },
                      builder: (context, state) {
                        if (state is LoadingState) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is GetCurrentWeatherSuccessState) {
                          return weather(state.weatherModel);
                        }
                        return emptyWeatherCard();
                      },
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: TabsWidget(city: 'Москва'),
            );
          }),
    );
  }

  /// Виджет пустой карточки (при начальном состоянии)
  Widget emptyWeatherCard() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundColorCard,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  /// Виджет отображения погоды
  Widget weather(WeatherModel weatherModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10, // было 80
        ),
        SizedBox(
          height: 145,
          width: 172,
          child: Container(
            alignment: Alignment.center,
            child: image(), //animation(),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              // When the user taps the button, show a snackbar.
              onTap: () {
                Navigator.pushNamed(context, '/selectCity',
                    arguments: 'CityMaps(city: null)');
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  weatherModel?.cityname ?? "--", // AppStrings.cityName,
                  style: AppTextStyles.headlineMedium,
                ),
              ),
            ),
            SizedBox(
              width: 11,
            ),
            locationVector(),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '${weatherModel?.temperature.toStringAsFixed(1) ?? "--"}°',
            //AppStrings.tempValue,
            style: AppTextStyles.headlineLarge,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            weatherModel?.description ?? '--',
            style: TextStyle(
              color: AppColors.textColors, // Задаем цвет текста
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        details(weatherModel),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  /// Поисковая строка
  Widget searchBar() {
    return SearchBar(
      controller: _searchController,
      // Подключаем контроллер для получения текста
      onSubmitted: _onSearchSubmitted,
      // обработка Enter/Поиск с клавиатуры
      backgroundColor:
      WidgetStateProperty.all(AppColors.backgroundColorSearchBar),
      // Цвет фона
      elevation: WidgetStateProperty.all(0),
      // Без тени
      hintText: AppStrings.searchHint,
      hintStyle: WidgetStateProperty.all(AppTextStyles.buttonText),
      trailing: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: AppColors.textColors2,
          ),
          onPressed: () {
            _onSearchSubmitted(_searchController.text.trim());
          },
        ),
      ],
    );
  }

  void _onSearchSubmitted(String city) async {
    if (city.isNotEmpty) {
      // Сохраняем город в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_city', city);

      // Отправляем событие в BLoC
      context.read<HomePageBloc>().add(GetCurrentWeatherEvent(city: city));
      FocusScope.of(context).unfocus(); // Скрываем клавиатуру
    }
    else {
      // показываем SnackBar, если поле пустое
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название города')),
      );
    }
  }

  /// Отображение дополнительных данных: УФ индекс, влажность, скорость ветра
  Widget details(WeatherModel weatherModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Column(
          //   children: [
          // Text(
          //   AppStrings.timeTitle,
          //   style: TextStyle(
          //     color: AppColors.textColors, // Задаем цвет текста
          //     fontSize: 12,
          //   ),
          // ),
          // Text(
          //   '', //_weather?.description ?? '--',
          //   style: TextStyle(
          //     color: AppColors.textColors, // Задаем цвет текста
          //     fontSize: 15,
          //   ),
          // ),
          //   ],
          // ),
          Column(
            children: [
              Text(
                AppStrings.uvTitle,
                style: TextStyle(
                  color: AppColors.textColors, // Задаем цвет текста
                  fontSize: 12,
                ),
              ),
              Text(
                '${weatherModel?.uvIndex ?? '--'}',
                style: TextStyle(
                  color: AppColors.textColors, // Задаем цвет текста
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                AppStrings.rainTitle,
                style: TextStyle(
                  color: AppColors.textColors, // Задаем цвет текста
                  fontSize: 12,
                ),
              ),
              Text(
                '${weatherModel?.humidity ?? "--"}',
                style: TextStyle(
                  color: AppColors.textColors, // Задаем цвет текста
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                AppStrings.aqTitle,
                style: TextStyle(
                  color: AppColors.textColors, // Задаем цвет текста
                  fontSize: 12,
                ),
              ),
              Text(
                weatherModel?.winSpeed.toStringAsFixed(1) ?? '--',
                style: TextStyle(
                  color: AppColors.textColors, // Задаем цвет текста
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget animation() {
    return SizedBox(
      width: 250,
      height: 250,
      child: Lottie.asset(
        'assets/animations/Sun2.json', // файл из Lottie
        width: 250,
        height: 250,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget image() {
    return Stack(
      clipBehavior: Clip.none, // не обрезает
      children: [
        SvgPicture.asset(
          'assets/image/sun.svg',
        ),
        Positioned(
          top: 43,
          //bottom: 22,
          //left: 13,
          right: 31,
          child: SvgPicture.asset(
            'assets/image/smallClound.svg',
          ),
        ),
        Positioned(
          top: 55,
          //bottom: 7,
          //left: 39,
          right: 31,
          child: SvgPicture.asset(
            'assets/image/bigClound.svg',
          ),
        ),
        Positioned(
          top: 81,
          //bottom: 16,
          //left: 18,
          right: 59,
          child: SvgPicture.asset(
            'assets/image/averageVector.svg',
          ),
        ),
      ],
    );
  }

  Widget locationVector() {
    return GestureDetector(
      onTap:
          () async {
        try {
          // Проверка разрешений
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Разрешение на геолокацию не предоставлено')),
              );
              return;
            }
          }

          // Получение координат
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          // Определяем адрес по координатам
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );

          if (placemarks.isNotEmpty) {
            final city = placemarks.first.locality ??
                placemarks.first.administrativeArea;
            if (city != null && city.isNotEmpty) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('last_city', city);
              context.read<HomePageBloc>().add(
                  GetCurrentWeatherEvent(city: city));
            }
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка геолокации: $e')),
          );
        }
      },
      child: SvgPicture.asset(
        'assets/image/locationVector.svg',
      ),
    );
  }

  void _checkFirstLaunchAndLoadCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('last_city');

    if (lastCity == null) {
      // Показываем диалог с вводом города
      await Future.delayed(Duration.zero); // Подождать пока построится context
      _showCityInputDialog();
    } else {
      // Загружаем погоду для сохранённого города
      context.read<HomePageBloc>().add(GetCurrentWeatherEvent(city: lastCity));
    }
  }

  Future<void> _showCityInputDialog() async {
    final TextEditingController _controller = TextEditingController();

    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white, // фиксированный белый фон
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Введите город',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // чёрный текст
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Например: Ташкент',
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      final city = _controller.text.trim();
                      if (city.isNotEmpty) {
                        Navigator.of(context).pop(city);
                      }
                    },
                    child: const Text(
                      'ОК',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) async {
      if (value != null && value.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_city', value);
        context.read<HomePageBloc>().add(GetCurrentWeatherEvent(city: value));
      }
    });
  }
}