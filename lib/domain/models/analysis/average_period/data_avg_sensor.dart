import 'package:frontend_water_quality/domain/models/analysis/data.dart';

class DataAvgSensor extends Data {
  List<AvgValue>? averages;

  DataAvgSensor({
    this.averages,
  });

  factory DataAvgSensor.fromJson(Map<String, dynamic> json) => DataAvgSensor(
        averages: json["averages"] == null
            ? []
            : List<AvgValue>.from(
                json["averages"]!.map((x) => AvgValue.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "averages": averages == null
            ? []
            : List<dynamic>.from(averages!.map((x) => x.toJson())),
      };
}

class AvgValue {
  DateTime? date;
  double? value;

  AvgValue({
    this.date,
    this.value,
  });

  factory AvgValue.fromJson(Map<String, dynamic> json) => AvgValue(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        value: json["value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "value": value,
      };
}
