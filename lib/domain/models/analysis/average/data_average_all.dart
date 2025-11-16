import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import 'package:frontend_water_quality/domain/models/analysis/data.dart';

class DataAverageAll extends Data {
  List<ResultAverage>? result;

  DataAverageAll({
    this.result,
  });

  factory DataAverageAll.fromJson(Map<String, dynamic> json) => DataAverageAll(
        result: json["result"] == null
            ? []
            : List<ResultAverage>.from(
                json["result"]!.map((x) => ResultAverage.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class ResultAverage {
  double? average;
  double? max;
  double? min;
  SensorType? sensor;

  ResultAverage({
    this.average,
    this.max,
    this.min,
    this.sensor,
  });

  factory ResultAverage.fromJson(Map<String, dynamic> json) => ResultAverage(
        average: json["average"]?.toDouble(),
        max: json["max"],
        min: json["min"]?.toDouble(),
        sensor: json["sensor"] == null
            ? null
            : SensorTypeExtension.fromString(json["sensor"]),
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "max": max,
        "min": min,
        "sensor": sensor?.nameEnglish,
      };
}
