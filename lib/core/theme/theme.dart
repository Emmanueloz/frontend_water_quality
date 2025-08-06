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
        headlineLarge: TextStyle(
          color: textColor,
          fontSize: 64,
          fontWeight: FontWeight.bold,
        ),
        displayLarge: TextStyle(
          color: textColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        titleSmall: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 18,
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
        titleTextStyle: textTheme.displaySmall,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      primaryTextTheme: textTheme,
      textTheme: textTheme,
      iconTheme: IconThemeData(
        color: colorScheme.secondary,
      ),
      listTileTheme: ListTileThemeData(
        textColor: textColor,
        iconColor: textColor,
        selectedColor: colorScheme.secondary,
        selectedTileColor: colorScheme.tertiary,
        titleTextStyle: textTheme.titleMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: textTheme.bodyMedium,
        iconColor: colorScheme.secondary,
        prefixIconColor: colorScheme.secondary,
        suffixIconColor: colorScheme.secondary,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colorScheme.primary, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colorScheme.primary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      cardColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 2,
        color: colorScheme.surface,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.tertiary,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(
          color: colorScheme.secondary,
        ),
        unselectedIconTheme: IconThemeData(
          color: textColor,
        ),
        indicatorColor: colorScheme.tertiary,
        selectedLabelTextStyle: textTheme.titleMedium,
        unselectedLabelTextStyle: textTheme.titleMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondary,
        labelStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.surface,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.surface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: colorScheme.secondary,
            width: 0,
          ),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        textColor: textColor,
        collapsedTextColor: textColor,
        iconColor: colorScheme.secondary,
        collapsedIconColor: colorScheme.secondary,
        shape: BeveledRectangleBorder(
          side: BorderSide.none,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        inputDecorationTheme: InputDecorationTheme(
          suffixIconColor: colorScheme.primary,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: colorScheme.secondary,
        textStyle: textTheme.bodyMedium,
        selectedColor: textColor,
        fillColor: colorScheme.tertiary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary, //#5bcdc5
          foregroundColor: colorScheme.surface,
          textStyle: textTheme.bodyMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.secondary, width: 1),
          foregroundColor: textColor,
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
