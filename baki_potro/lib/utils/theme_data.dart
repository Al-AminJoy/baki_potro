import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common.dart';
class ThemesData{
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.orange,
    scaffoldBackgroundColor: Colors.white12,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      //brightness: Brightness.light,
        color: Colors.white12,
        systemOverlayStyle:
        SystemUiOverlayStyle(statusBarColor: Colors.white10)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white24,
    ),
    cardColor: Colors.black12,
  );

  static ThemeData light = ThemeData(
      brightness: Brightness.light,
      //  backgroundColor:Colors.white70,
      accentColor: Colors.green,
      primarySwatch: Colors.green,
      primaryColor: Colors.green,
      scaffoldBackgroundColor: Common.whiteShade,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
        ),
      ),
      appBarTheme: AppBarTheme(
        //brightness: Brightness.light,
          color: Colors.green,
          systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Colors.lightGreen)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.white, backgroundColor: Colors.green),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
      ));
}
