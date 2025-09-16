import 'package:flutter/material.dart';

class AppTheme {
  static const Color textColor = Color(0xff040c13); //#040c13

  // Paleta base (CSS → Flutter)
  static const Color robinEggBlue = Color(0xff5bcdc5); // #5bcdc5
  static const Color robinEggBlue2 = Color(0xff53c6bd); // #53c6bd
  static const Color verdigris = Color(0xff51c0b5); // #51c0b5
  static const Color keppel = Color(0xff4fbaac); // #4fbaac

  // MaterialColor para usar como primarySwatch
  static const MaterialColor primarySwatch = MaterialColor(
    0xff5bcdc5, // valor principal
    <int, Color>{
      50: Color(0xffe0f7f6),
      100: Color(0xffb3e8e5),
      200: Color(0xff80d9d3),
      300: Color(0xff4dcac1),
      400: Color(0xff26c0b6),
      500: Color(0xff5bcdc5), // color base
      600: Color(0xff53c6bd),
      700: Color(0xff51c0b5),
      800: Color(0xff4fbaac),
      900: Color(0xff3da397),
    },
  );

  static ColorScheme get colorScheme => const ColorScheme.light(
        primary: robinEggBlue,
        secondary: robinEggBlue2,
        tertiary: verdigris,
        surface: Color(0xffefefef),
        primaryContainer: Colors.white,
        surfaceContainer: Color(0xfff6f9fb),
        tertiaryContainer: keppel,
        onPrimary: Colors.white,
        onSecondary: textColor,
        onTertiary: textColor,
        onSurface: textColor,
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
      primarySwatch: primarySwatch, // ahora con tu paleta
      primaryColor: colorScheme.primary,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        actionsPadding: const EdgeInsets.all(4),
        backgroundColor: colorScheme.primaryContainer,
        elevation: 1,
        actionsIconTheme: IconThemeData(color: colorScheme.primary),
        iconTheme: IconThemeData(color: colorScheme.primary),
        titleTextStyle: textTheme.displaySmall,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      dividerTheme: DividerThemeData(color: colorScheme.primary),
      primaryTextTheme: textTheme,
      textTheme: textTheme,
      iconTheme: IconThemeData(color: colorScheme.primary),
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
        indicatorColor: colorScheme.surface,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.primary,
        selectedIconTheme: IconThemeData(color: colorScheme.surface),
        unselectedIconTheme: const IconThemeData(color: textColor),
        indicatorColor: colorScheme.tertiary,
        selectedLabelTextStyle:
            textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelTextStyle: textTheme.titleMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primary,
        labelStyle: textTheme.bodySmall,
        iconTheme: IconThemeData(color: textColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: colorScheme.secondary, width: 0),
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
          backgroundColor: colorScheme.primary,
          foregroundColor: textColor,
          textStyle: textTheme.bodyMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary, width: 1),
          foregroundColor: textColor,
          textStyle: textTheme.bodyMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          iconColor: colorScheme.primary,
          foregroundColor: textColor,
          textStyle: textTheme.bodyMedium,
        ),
      ),
    );
  }
}
