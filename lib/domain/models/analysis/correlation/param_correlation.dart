import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';

class ParamCorrelation extends Parameters {
  String? periodType;
  String? method;
  List<SensorType>? sensors;

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
        sensor: json["sensor_type"] == null
            ? null
            : SensorTypeExtension.fromString(json["sensor_type"]),
        periodType: json["period_type"],
        sensors: json["sensors"] == null
            ? []
            : List<SensorType>.from(
                json["sensors"]!.map((x) => SensorTypeExtension.fromString(x)),
              ),
      );

  @override
  Map<String, dynamic> toJson() => {
        "end_date": endDate?.toIso8601String(),
        "start_date": startDate?.toIso8601String(),
        if (sensor != null) "sensor_type": sensor!.nameEnglish,
        "period_type": periodType,
        "method": method,
        "sensors": sensors == null
            ? []
            : List<dynamic>.from(
                sensors!.map((x) => x.nameEnglish),
              ),
      };
}
