import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  inputDecorationTheme: const InputDecorationTheme(
    isDense: true,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  inputDecorationTheme: const InputDecorationTheme(
    isDense: true,
  ),
  textTheme: const TextTheme(
    headline6: TextStyle(fontSize: 20),
  ),
);
