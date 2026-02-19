import 'package:flutter/material.dart';

class AppColors {
  static Color primary = const Color.fromRGBO(118, 121, 249, 1);
  static Color secondary = const Color.fromRGBO(121, 8, 168, 1);
  static Color accent = const Color.fromARGB(255, 207, 73, 203);
  static Color background = const Color.fromRGBO(1, 4, 29, 1);
  static Color text = const Color.fromRGBO(229, 229, 254, 1);
}

ThemeData primaryTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),

  scaffoldBackgroundColor: AppColors.background,

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.secondary,
    foregroundColor: AppColors.text,
    centerTitle: true,
  ),

  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: AppColors.text,
      fontSize: 16,
      letterSpacing: 1,
    ),
    headlineMedium: TextStyle(
      color: AppColors.text,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
    titleLarge: TextStyle(
      color: AppColors.text,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  ),

  cardTheme: CardThemeData(
    color: AppColors.secondary.withValues(alpha: 0.5),
    shape: const RoundedRectangleBorder(),
    margin: const EdgeInsets.only(bottom: 16),
  ),

  scrollbarTheme: ScrollbarThemeData(
    thumbColor: WidgetStateProperty.all(AppColors.accent.withAlpha(100)),
  ),
);
