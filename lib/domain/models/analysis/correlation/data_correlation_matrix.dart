import 'package:frontend_water_quality/core/enums/sensor_type.dart';

class DataCorrelationMatrix {
  List<List<double>>? matrix;
  String? method;
  List<SensorType>? sensors;

  DataCorrelationMatrix({
    this.matrix,
    this.method,
    this.sensors,
  });

  factory DataCorrelationMatrix.fromJson(Map<String, dynamic> json) =>
      DataCorrelationMatrix(
        matrix: json["matrix"] == null
            ? []
            : List<List<double>>.from(json["matrix"]!
                .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
        method: json["method"],
        sensors: json["sensors"] == null
            ? []
            : List<SensorType>.from(json["sensors"]!
                .map((x) => SensorTypeExtension.fromString(x))),
      );

  Map<String, dynamic> toJson() => {
        "matrix": matrix == null
            ? []
            : List<dynamic>.from(
                matrix!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "method": method,
        "sensors": sensors == null
            ? []
            : List<dynamic>.from(sensors!.map((x) => x.nameEnglish)),
      };
}
