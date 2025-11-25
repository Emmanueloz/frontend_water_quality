import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import 'package:frontend_water_quality/domain/models/analysis/data.dart';

class DataAverageSensor extends Data {
  SensorType? sensor;
  Stats? stats;

  DataAverageSensor({
    this.sensor,
    this.stats,
  });

  factory DataAverageSensor.fromJson(Map<String, dynamic> json) =>
      DataAverageSensor(
        sensor: json["sensor"] == null
            ? null
            : SensorTypeExtension.fromString(json["sensor"]),
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "sensor": sensor?.nameEnglish,
        "stats": stats?.toJson(),
      };
}

class Stats {
  double? average;
  double? max;
  double? min;

  Stats({
    this.average,
    this.max,
    this.min,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        average: json["average"]?.toDouble(),
        max: json["max"],
        min: json["min"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "max": max,
        "min": min,
      };
}
