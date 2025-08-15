import 'package:flutter/material.dart';
import 'package:weather_app/home/home_page.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/strings.dart';
import 'package:weather_icons/weather_icons.dart';

import 'hour/hourly_weather_page.dart';
import 'utils/text_styles.dart';

class TabsWidget extends StatefulWidget {
  final String city;
  const TabsWidget({super.key, required this.city});

  @override
  State<TabsWidget> createState() => _TabsWidgetState();
}

class _TabsWidgetState extends State<TabsWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index){
      case 0: Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      case 1: Navigator.push(context, MaterialPageRoute(builder: (context) => HourlyWeatherPage(city: widget.city,)));
      break;
    }


  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: AppColors.backgroundColorUI,
      selectedItemColor: AppColors.textColors,  // ← цвет активной иконки + текста
      unselectedItemColor: AppColors.textColors, // ← цвет остальных
        selectedLabelStyle:  AppTextStyles.buttonText, // Стиль текста активной вкладки
        unselectedLabelStyle:AppTextStyles.buttonText, // Стиль текста неактивной вкладки
      items: const [
        BottomNavigationBarItem(
          icon: BoxedIcon(WeatherIcons.day_cloudy),
          label: AppStrings.tabFirstText,

        ),
        BottomNavigationBarItem(
          icon: BoxedIcon(WeatherIcons.time_3),
          label: AppStrings.tabSecondText,
        ),

      ],
    );
  }
}