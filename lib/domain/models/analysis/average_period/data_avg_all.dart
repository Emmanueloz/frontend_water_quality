import 'package:frontend_water_quality/domain/models/analysis/data.dart';

class DataAvgAll extends Data {
  SensorSpots? conductivity;
  SensorSpots? ph;
  SensorSpots? tds;
  SensorSpots? temperature;
  SensorSpots? turbidity;

  DataAvgAll({
    this.conductivity,
    this.ph,
    this.tds,
    this.temperature,
    this.turbidity,
  });

  factory DataAvgAll.fromJson(Map<String, dynamic> json) => DataAvgAll(
        conductivity: json["conductivity"] == null
            ? null
            : SensorSpots.fromJson(json["conductivity"]),
        ph: json["ph"] == null ? null : SensorSpots.fromJson(json["ph"]),
        tds: json["tds"] == null ? null : SensorSpots.fromJson(json["tds"]),
        temperature: json["temperature"] == null
            ? null
            : SensorSpots.fromJson(json["temperature"]),
        turbidity: json["turbidity"] == null
            ? null
            : SensorSpots.fromJson(json["turbidity"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "conductivity": conductivity?.toJson(),
        "ph": ph?.toJson(),
        "tds": tds?.toJson(),
        "temperature": temperature?.toJson(),
        "turbidity": turbidity?.toJson(),
      };
}

class SensorSpots {
  List<DateTime?>? labels;
  List<double?>? values;

  SensorSpots({
    this.labels,
    this.values,
  });

  factory SensorSpots.fromJson(Map<String, dynamic> json) => SensorSpots(
        labels: json["labels"] == null
            ? []
            : List<DateTime>.from(
                json["labels"]!.map((x) => DateTime.parse(x))),
        values: json["values"] == null
            ? []
            : List<double>.from(json["values"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "labels": labels == null
            ? []
            : List<dynamic>.from(labels!.map((x) => x?.toIso8601String())),
        "values":
            values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
      };
}
