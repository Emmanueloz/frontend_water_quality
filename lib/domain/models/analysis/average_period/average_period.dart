import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/param_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:frontend_water_quality/domain/models/analysis/data.dart';

class AveragePeriod extends BaseAnalysis<Data, ParamPeriod> {
  AveragePeriod({
    super.id,
    super.createdAt,
    super.data,
    super.error,
    super.meterId,
    super.parameters,
    super.status,
    super.type,
    super.updatedAt,
    super.workspaceId,
  });

  factory AveragePeriod.fromJson(Map<String, dynamic> json, String id) {
    final param = ParamPeriod.fromJson(json["parameters"]);

    print(json["data"]["results"]);

    return AveragePeriod(
      id: id,
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      data: json["data"] == null
          ? null
          : param.sensor != null
              ? DataAvgSensor.fromJson(json["data"])
              : DataAvgAll.fromJson(json["data"]["results"]),
      error: json["error"],
      meterId: json["meter_id"],
      parameters: json["parameters"] == null ? null : param,
      status: json["status"],
      type: json["type"],
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      workspaceId: json["workspace_id"],
    );
  }
}
