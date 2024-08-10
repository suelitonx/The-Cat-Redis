import 'package:flutter/material.dart';

ThemeData originalMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surfaceContainerHighest: Colors.transparent,
    surface: Colors.grey.shade200,
    onSurface: Colors.black,
    primary: const Color(0xFFFe3c72),
    onPrimary: Colors.black,
    secondary: const Color(0xFF424242),
    onSecondary: Colors.white,
    tertiary: const Color.fromRGBO(255, 204, 128, 1),
    error: Colors.red,
    outline: const Color(0xFF424242),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    onSurface: Colors.white,
    primary: const Color(0xFFFe3c72),
    onPrimary: Colors.black,
    secondary: const Color(0xFF424242),
    onSecondary: Colors.white,
    tertiary: const Color.fromRGBO(255, 204, 128, 1),
    error: Colors.red,
    outline: const Color(0xFF424242),
  ),
);
