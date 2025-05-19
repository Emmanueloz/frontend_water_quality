import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF5BCDC5), //#5bcdc5
      colorScheme: const ColorScheme.light(
        primary: Color.fromRGBO(91, 205, 197, 1), //#5bcdc5
        secondary: Color(0xffdcf2f1), //#dcf2f1
        surface: Color(0xFFBAE0DE), //#bae0de
        primaryContainer: Color.fromRGBO(47, 201, 221, 1),
        secondaryContainer: Color.fromRGBO(47, 201, 221, 1),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF5BCDC5), //#5bcdc5
        foregroundColor: Colors.black,
        elevation: 0,
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: Color.fromARGB(255, 180, 180, 180), //#f8f8f8
      primaryTextTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        bodySmall: TextStyle(
          color: Colors.black,
          fontSize: 10,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        subtitleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        selectedColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5BCDC5), //#5bcdc5
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          textStyle: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
