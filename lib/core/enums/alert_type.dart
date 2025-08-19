enum AlertType {
  excellent,
  good,
  moderate,
  poor,
  dangerous,
}

extension AlertTypeExtension on AlertType {
  String get nameSpanish {
    switch (this) {
      case AlertType.excellent:
        return "Excelente";
      case AlertType.good:
        return "Bueno";
      case AlertType.moderate:
        return "Moderado";
      case AlertType.poor:
        return "Malo";
      case AlertType.dangerous:
        return "Peligroso";
    }
  }

  static AlertType fromName(String name) {
    switch (name.toLowerCase()) {
      case "excellent":
        return AlertType.excellent;
      case "good":
        return AlertType.good;
      case "moderate":
        return AlertType.moderate;
      case "poor":
        return AlertType.poor;
      case "dangerous":
        return AlertType.dangerous;
      default:
        throw ArgumentError("Unknown alert type: $name");
    }
  }
} 