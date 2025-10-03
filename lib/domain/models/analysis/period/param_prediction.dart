import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';

class ParamPrediction extends Parameters {
  String? periodType;
  int? ahead;

  ParamPrediction({
    super.startDate,
    super.endDate,
    super.sensor,
    this.periodType,
    this.ahead,
  });

  factory ParamPrediction.fromJson(Map<String, dynamic> json) =>
      ParamPrediction(
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        periodType: json["period_type"],
        sensor: json["sensor_type"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        ahead: json["ahead"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "end_date": endDate?.toIso8601String(),
        "period_type": periodType,
        if (sensor != null) "sensor_type": sensor,
        "start_date": startDate?.toIso8601String(),
        "ahead": ahead,
      };
}
