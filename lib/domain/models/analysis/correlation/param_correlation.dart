import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';

class ParamCorrelation extends Parameters {
  String? periodType;
  String? method;
  List<String>? sensors;

  ParamCorrelation({
    super.endDate,
    super.startDate,
    super.sensor,
    this.periodType,
    this.method,
    this.sensors,
  });

  factory ParamCorrelation.fromJson(Map<String, dynamic> json) =>
      ParamCorrelation(
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        sensor: json["sensor_type"],
        periodType: json["period_type"],
        sensors: json["sensors"] == null
            ? []
            : List<String>.from(
                json["sensors"]!.map((x) => x),
              ),
      );
}
