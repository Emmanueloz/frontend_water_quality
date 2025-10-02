enum SensorType {
  ph,
  temperature,
  tds,
  turbidity,
  conductivity;
}

extension SensorTypeLabel on SensorType {
  String get label {
    switch (this) {
      case SensorType.ph:
        return 'pH';
      case SensorType.temperature:
        return 'Temperatura';
      case SensorType.tds:
        return 'TDS';
      case SensorType.turbidity:
        return 'Turbidez';
      case SensorType.conductivity:
        return 'Conductividad';
    }
  }

  String get value => name;
}
