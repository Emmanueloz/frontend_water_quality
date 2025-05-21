import 'package:flutter/material.dart';

class AppTheme {
  static const Color textColor = Color(0xff004E49); //#424a4d

  static ColorScheme get colorScheme => const ColorScheme.light(
        primary: Color(0xff5accc4), //
        secondary: Color(0xff145c57),
        tertiary: Color(0xffbfe7e4),
        surface: Color(0xfff7fafa),
        primaryContainer: Color(0xff145c57),
        secondaryContainer: Color(0xff5accc4),
        tertiaryContainer: Color(0xffbfe7e4),
        surfaceContainer: Color(0xfff7fafa),
      );

  static TextTheme get textTheme => const TextTheme(
        displayLarge: TextStyle(
          color: textColor,
          fontSize: 40,
        ),
        displayMedium: TextStyle(
          color: textColor,
          fontSize: 34,
        ),
        displaySmall: TextStyle(
          color: textColor,
          fontSize: 28,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontSize: 14,
        ),
        titleSmall: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 20,
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        bodySmall: TextStyle(
          color: textColor,
          fontSize: 10,
        ),
      );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.cyan,
      primaryColor: colorScheme.primary,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.surface,
        elevation: 0,
        actionsIconTheme: IconThemeData(
          color: colorScheme.secondary,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.secondary,
        ),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      primaryTextTheme: textTheme,
      textTheme: textTheme,
      iconTheme: IconThemeData(
        color: colorScheme.secondary,
      ),
      listTileTheme: ListTileThemeData(
        textColor: textColor,
      ),
      cardColor: colorScheme.surface,
      cardTheme: CardTheme(
        elevation: 2,
        color: colorScheme.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary, //#5bcdc5
          foregroundColor: colorScheme.surface,
          textStyle: textTheme.bodyMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textColor, //#5bcdc5
          textStyle: textTheme.bodyMedium,
        ),
      ),
    );
  }
}
