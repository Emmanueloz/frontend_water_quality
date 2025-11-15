import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';

class ParamPeriod extends Parameters {
  String? periodType;

  ParamPeriod({
    super.startDate,
    super.endDate,
    super.sensor,
    this.periodType,
  });

  factory ParamPeriod.fromJson(Map<String, dynamic> json) => ParamPeriod(
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        periodType: json["period_type"],
        sensor: json["sensor_type"] == null
            ? null
            : SensorTypeExtension.fromString(json["sensor_type"]),
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "end_date": endDate?.toIso8601String(),
        "period_type": periodType,
        if (sensor != null) "sensor_type": sensor!.nameEnglish,
        "start_date": startDate?.toIso8601String(),
      };
}
