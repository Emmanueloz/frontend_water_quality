import 'package:flutter/material.dart';

class AppTheme {
  static const Color textColor = Color(0xff000000); // 0, 0, 0
  static const Color _darkTextColor = Color(0xFFE6F7F5);

  static ColorScheme get colorScheme => ColorScheme.light(
        primary: const Color(0xFF386b70),
        onPrimary: textColor,
        secondary: const Color(0xFFE4F3F1),
        onSecondary: textColor,
        tertiary: const Color(0xFF5bcdc5),
        onTertiary: textColor,
        surface: const Color(0xFFE4F3F1),
        onSurface: textColor,
        primaryContainer: const Color.fromARGB(255, 239, 247, 246),
        surfaceContainer: const Color(0xFF49ace1),
        shadow: Color.fromARGB(211, 255, 255, 255),
      );

  static ColorScheme get darkColorScheme => ColorScheme.dark(
        primary: const Color(0xFF386b70), // header teal oscuro
        onPrimary: _darkTextColor,
        secondary: const Color.fromARGB(255, 0, 15, 23),
        onSecondary: _darkTextColor,
        tertiary: const Color(0xFF2BE0D6), // acento brillante
        onTertiary: _darkTextColor,
        surface: const Color(0xFF001b26), // fondo cards/áreas
        onSurface: _darkTextColor,
        onInverseSurface: const Color.fromARGB(255, 2, 24, 32),
        primaryContainer: const Color.fromARGB(255, 239, 247, 246),
        surfaceContainer: const Color.fromARGB(69, 0, 27, 38),
        shadow: Color(0xFFF4F8F9).withAlpha(38),
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
        backgroundColor: colorScheme.secondary,
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
      iconTheme: IconThemeData(color: colorScheme.tertiary),
      listTileTheme: ListTileThemeData(
        textColor: textColor,
        iconColor: textColor,
        selectedColor: colorScheme.secondary,
        selectedTileColor: colorScheme.tertiary,
        titleTextStyle: textTheme.titleMedium,
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
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
      cardTheme: CardThemeData(
        elevation: 1,
        color: colorScheme.primaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.4),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(
            color: colorScheme.secondary,
          ),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.bodySmall?.copyWith(
            color: colorScheme.surface,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: const Color(0xFF386b70),
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
        labelStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
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

  static ThemeData get darkTheme {
    //final cs = darkColorScheme;
    final darkTextTheme = textTheme.apply(
      bodyColor: darkColorScheme.onSurface,
      displayColor: darkColorScheme.onSurface,
    );

    return ThemeData(
      // brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: darkColorScheme,
      primaryColor: darkColorScheme.primary,
      // Fondos
      scaffoldBackgroundColor: darkColorScheme.secondary,
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.secondary,
        actionsPadding: const EdgeInsets.all(4),
        elevation: 0,
        titleTextStyle: darkTextTheme.displaySmall
            ?.copyWith(color: darkColorScheme.onPrimary),
        iconTheme: IconThemeData(color: darkColorScheme.onSecondary),
        actionsIconTheme: IconThemeData(color: darkColorScheme.onSurface),
      ),
      // Textos
      textTheme: darkTextTheme,
      primaryTextTheme: darkTextTheme,
      iconTheme: IconThemeData(color: darkColorScheme.onSurface),
      // Tarjetas
      cardTheme: CardThemeData(
        color: darkColorScheme.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      // Divisor
      dividerTheme: DividerThemeData(
        color: darkColorScheme.tertiary.withValues(alpha: 0.2),
        thickness: 1,
      ),
      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: darkTextTheme.bodyMedium
            ?.copyWith(color: darkColorScheme.onSurface),
        hintStyle: darkTextTheme.bodyMedium
            ?.copyWith(color: darkColorScheme.onSurface.withValues(alpha: 0.6)),
        iconColor: darkColorScheme.tertiary,
        prefixIconColor: darkColorScheme.tertiary,
        suffixIconColor: darkColorScheme.tertiary,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: darkColorScheme.tertiary.withValues(alpha: 0.3), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: darkColorScheme.tertiary.withValues(alpha: 0.3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: darkColorScheme.tertiary, width: 2),
        ),
        fillColor: darkColorScheme.secondary.withAlpha(74),
        filled: true,
        // fillColor: cs.surfaceContainer
      ),
      // ListTile
      listTileTheme: ListTileThemeData(
        textColor: darkColorScheme.onSurface,
        iconColor: darkColorScheme.tertiary,
        selectedColor: darkColorScheme.tertiary,
        selectedTileColor: darkColorScheme.tertiary.withValues(alpha: 0.15),
        titleTextStyle: darkTextTheme.titleMedium,
      ),
      // Data Table
      dataTableTheme: DataTableThemeData(
        headingTextStyle: darkTextTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: darkColorScheme.tertiary,
        ),
        dataTextStyle: darkTextTheme.bodyMedium
            ?.copyWith(color: darkColorScheme.onSurface),
        decoration: BoxDecoration(
          color: darkColorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: darkColorScheme.onInverseSurface,
        indicatorColor: darkColorScheme.tertiary,
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: darkColorScheme.onSurface),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          darkTextTheme.bodySmall?.copyWith(color: darkColorScheme.onSurface),
        ),
      ),
      // Navigation Rail
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: darkColorScheme.onInverseSurface,
        selectedIconTheme: IconThemeData(color: darkColorScheme.tertiary),
        unselectedIconTheme: IconThemeData(
            color: darkColorScheme.onSurface.withValues(alpha: 0.6)),
        indicatorColor: darkColorScheme.tertiary.withValues(alpha: 0.2),
        selectedLabelTextStyle: darkTextTheme.titleMedium?.copyWith(
          color: darkColorScheme.tertiary,
        ),
        unselectedLabelTextStyle: darkTextTheme.titleMedium?.copyWith(
          color: darkColorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: darkColorScheme.tertiary.withValues(alpha: 0.15),
        labelStyle: darkTextTheme.bodySmall?.copyWith(
          color: darkColorScheme.tertiary,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: darkColorScheme.tertiary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: darkColorScheme.tertiary.withValues(alpha: 0.5), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      // Expansion Tile
      expansionTileTheme: ExpansionTileThemeData(
        textColor: darkColorScheme.onSurface,
        collapsedTextColor: darkColorScheme.onSurface,
        iconColor: darkColorScheme.tertiary,
        collapsedIconColor: darkColorScheme.tertiary,
        shape: const BeveledRectangleBorder(side: BorderSide.none),
      ),
      // Dropdown Menu
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle:
            darkTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        inputDecorationTheme: InputDecorationTheme(
          suffixIconColor: darkColorScheme.tertiary,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: darkColorScheme.tertiary.withValues(alpha: 0.3),
                width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: darkColorScheme.tertiary, width: 2),
          ),
          filled: true,
          fillColor: darkColorScheme.surface,
        ),
      ),
      // Toggle Buttons
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: darkColorScheme.onSurface.withValues(alpha: 0.6),
        textStyle: darkTextTheme.bodyMedium,
        selectedColor: darkColorScheme.onSurface,
        fillColor: darkColorScheme.tertiary.withValues(alpha: 0.2),
      ),
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.tertiary,
          foregroundColor: darkColorScheme.secondary,
          textStyle: darkTextTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
      ),
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: darkColorScheme.tertiary, width: 1.5),
          foregroundColor: darkColorScheme.tertiary,
          textStyle:
              darkTextTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: darkColorScheme.tertiary.withValues(alpha: 0.15),
          foregroundColor: darkColorScheme.tertiary,
        ),
      ),
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkColorScheme.tertiary,
          textStyle: darkTextTheme.bodyMedium,
        ),
      ),
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.tertiary,
        foregroundColor: darkColorScheme.onTertiary,
        elevation: 4,
        hoverElevation: 8,
      ),
    );
  }
}
