import 'package:frontend_water_quality/domain/models/analysis/data.dart';

class DataAvgAll extends Data {
  List<AvgAllValue>? averages;

  DataAvgAll({
    this.averages,
  });

  factory DataAvgAll.fromJson(Map<String, dynamic> json) => DataAvgAll(
        averages: json["averages"] == null
            ? []
            : List<AvgAllValue>.from(
                json["averages"]!.map((x) => AvgAllValue.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "averages": averages == null
            ? []
            : List<dynamic>.from(averages!.map((x) => x.toJson())),
      };
}

class AvgAllValue {
  AvgAllSensors? averages;
  DateTime? date;

  AvgAllValue({
    this.averages,
    this.date,
  });

  factory AvgAllValue.fromJson(Map<String, dynamic> json) => AvgAllValue(
        averages: json["averages"] == null
            ? null
            : AvgAllSensors.fromJson(json["averages"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "averages": averages?.toJson(),
        "date": date?.toIso8601String(),
      };
}

class AvgAllSensors {
  double? conductivity;
  double? ph;
  double? tds;
  double? temperature;
  double? turbidity;

  AvgAllSensors({
    this.conductivity,
    this.ph,
    this.tds,
    this.temperature,
    this.turbidity,
  });

  factory AvgAllSensors.fromJson(Map<String, dynamic> json) => AvgAllSensors(
        conductivity: json["conductivity"]?.toDouble(),
        ph: json["ph"]?.toDouble(),
        tds: json["tds"]?.toDouble(),
        temperature: json["temperature"]?.toDouble(),
        turbidity: json["turbidity"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "conductivity": conductivity,
        "ph": ph,
        "tds": tds,
        "temperature": temperature,
        "turbidity": turbidity,
      };
}
