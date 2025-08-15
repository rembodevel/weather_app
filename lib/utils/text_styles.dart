import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';

class AppTextStyles {
  /// Крупный заголовок
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  /// Средний заголовок
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle headlineMediumCity = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  /// Обычный текст
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  /// Второстепенный текст
  static const TextStyle bodySecondary = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  /// Текст на кнопках
  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textColors2,
  );

  /// Подпись или вспомогательный текст
  static const TextStyle caption = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.grey,
  );
}