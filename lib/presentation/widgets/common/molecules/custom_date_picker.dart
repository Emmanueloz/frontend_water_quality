import 'package:flutter/material.dart';

class CustomDatePicker {
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    return showDatePicker(
      context: context,
      // Force Spanish locale for the date picker dialog
      locale: const Locale('es', 'ES'),
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              // Estilo para los días del calendario
              bodyLarge: TextStyle(fontSize: 14),
              bodyMedium: TextStyle(fontSize: 14),
              // Estilo para el encabezado del mes/año
              titleMedium: TextStyle(fontSize: 16),
              titleLarge: TextStyle(fontSize: 16),
              headlineMedium: TextStyle(fontSize: 16),
              // Estilo para los botones
              labelLarge: TextStyle(fontSize: 14),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
