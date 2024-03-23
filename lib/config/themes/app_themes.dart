import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData darkThemeData = ThemeData(
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: HexColor("#5b86e5"),
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
        color: Colors.black, titleTextStyle: TextStyle(color: Colors.white)));
ThemeData lightThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: HexColor("#5b86e5"),
    primary: HexColor("#5b86e5"),
  ),
  iconTheme: IconThemeData(color: HexColor("#5b86e5")),
  iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: HexColor("#5b86e5"))),
  useMaterial3: true,
);
