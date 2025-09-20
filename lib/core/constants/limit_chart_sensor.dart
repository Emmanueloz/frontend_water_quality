class LimitChartSensor {
  static double getMaxY(String sensor) {
    switch (sensor) {
      case "temperature":
        return 60;
      case "ph":
        return 14.0;
      case "tds":
        return 700.0;
      case "conductivity":
        return 3000.0;
      case "turbidity":
        return 70;
      default:
        return 0;
    }
  }
}
