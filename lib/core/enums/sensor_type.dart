enum SensorType {
  ph,
  conductivity,
  temperature,
  tds,
  turbidity;
}

extension SensorTypeExtension on SensorType {
  String get nameSpanish {
    switch (this) {
      case SensorType.ph:
        return 'pH';
      case SensorType.conductivity:
        return 'Conductividad';
      case SensorType.temperature:
        return 'Temperatura';
      case SensorType.tds:
        return 'TDS';
      case SensorType.turbidity:
        return 'Turbidez';
    }
  }

  String get nameEnglish {
    switch (this) {
      case SensorType.ph:
        return 'PH';
      case SensorType.conductivity:
        return 'CONDUCTIVITY';
      case SensorType.temperature:
        return 'TEMPERATURE';
      case SensorType.tds:
        return 'TDS';
      case SensorType.turbidity:
        return 'TURBIDITY';
    }
  }

  static SensorType fromString(String value) {
    final normalized = value.toUpperCase().replaceAll('_', '').replaceAll('-', '');
    
    switch (normalized) {
      case 'PH':
        return SensorType.ph;
      case 'CONDUCTIVITY':
        return SensorType.conductivity;
      case 'TEMPERATURE':
        return SensorType.temperature;
      case 'TDS':
        return SensorType.tds;
      case 'TURBIDITY':
        return SensorType.turbidity;
      default:
        throw ArgumentError('Unknown sensor type: $value');
    }
  }
}
