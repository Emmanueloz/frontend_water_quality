import 'package:flutter/material.dart';

class AppTheme {
  static const Color textColor = Color(0xff000000); // 0, 0, 0

  static ColorScheme get colorScheme => ColorScheme.light(
        primary: const Color(0xFF2563ab),
        onPrimary: textColor,
        secondary: const Color(0xFF2563ab),
        onSecondary: textColor,
        tertiary: const Color(0xFF5bcdc5),
        onTertiary: textColor,
        surface: const Color.fromARGB(255, 228, 243, 241),
        onSurface: textColor,
        primaryContainer: const Color.fromARGB(255, 239, 247, 246),
        surfaceContainer: const Color(0xFF49ace1),
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
      primaryColor: colorScheme.primary,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        actionsPadding: const EdgeInsets.all(4),
        color: colorScheme.surface,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: colorScheme.onPrimary),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        titleTextStyle:
            textTheme.displaySmall?.copyWith(color: colorScheme.onPrimary),
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      dividerTheme: DividerThemeData(color: colorScheme.primary),
      primaryTextTheme: textTheme,
      textTheme: textTheme,
      iconTheme: IconThemeData(color: colorScheme.surface),
      listTileTheme: ListTileThemeData(
        textColor: textColor,
        iconColor: textColor,
        selectedColor: colorScheme.secondary,
        selectedTileColor: colorScheme.tertiary,
        titleTextStyle: textTheme.titleMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: textTheme.bodyMedium,
        iconColor: colorScheme.primary,
        prefixIconColor: colorScheme.secondary,
        suffixIconColor: colorScheme.secondary,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colorScheme.primary, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colorScheme.primary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: colorScheme.primaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: colorScheme.secondary,
        indicatorColor: colorScheme.tertiary,
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(
            color: colorScheme.surface,
          ),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.bodySmall?.copyWith(
            color: colorScheme.surface,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.primary,
        selectedIconTheme: IconThemeData(color: colorScheme.onPrimary),
        unselectedIconTheme: IconThemeData(color: colorScheme.surface),
        indicatorColor: colorScheme.tertiary,
        selectedLabelTextStyle: textTheme.titleMedium?.copyWith(
          color: colorScheme.surface,
        ),
        unselectedLabelTextStyle: textTheme.titleMedium?.copyWith(
          color: colorScheme.surface,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.tertiary,
        labelStyle: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
        iconTheme: IconThemeData(color: colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: colorScheme.tertiary, width: 0),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        textColor: textColor,
        collapsedTextColor: textColor,
        iconColor: colorScheme.secondary,
        collapsedIconColor: colorScheme.secondary,
        shape: const BeveledRectangleBorder(side: BorderSide.none),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        inputDecorationTheme: InputDecorationTheme(
          suffixIconColor: colorScheme.primary,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
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
          backgroundColor: colorScheme.tertiary,
          foregroundColor: textColor,
          textStyle: textTheme.bodyMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.tertiary, width: 1),
          foregroundColor: textColor,
          textStyle: textTheme.bodyMedium,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.tertiary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          textStyle: textTheme.bodyMedium,
        ),
      ),
    );
  }
}
