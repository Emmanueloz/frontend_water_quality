mixin DateParserMixin {
  DateTime parseFlexibleDate(dynamic dateStr) {
    if (dateStr is DateTime) return dateStr;

    String str = dateStr.toString().trim();

    try {
      // Intenta parsear normalmente (fecha completa)
      return DateTime.parse(str);
    } catch (e) {
      // Solo año (YYYY)
      if (RegExp(r'^\d{4}$').hasMatch(str)) {
        return DateTime(int.parse(str));
      }

      // Año-Mes (YYYY-MM)
      if (RegExp(r'^\d{4}-\d{2}$').hasMatch(str)) {
        final parts = str.split('-');
        return DateTime(int.parse(parts[0]), int.parse(parts[1]));
      }

      // Si nada funciona, lanza error con mensaje descriptivo
      throw FormatException('Formato de fecha no válido: $str');
    }
  }
}
