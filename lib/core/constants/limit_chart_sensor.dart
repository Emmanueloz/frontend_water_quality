import 'package:frontend_water_quality/core/enums/sensor_type.dart';

class LimitChartSensor {
  static double getMaxY(SensorType sensor) {
    switch (sensor) {
      case SensorType.temperature:
        return 60;
      case SensorType.ph:
        return 14.0;
      case SensorType.tds:
        return 1200.0;
      case SensorType.conductivity:
        return 1800.0;
      case SensorType.turbidity:
        return 500;
    }
  }
}
