import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:frontend_water_quality/domain/models/analysis/data.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/data_average_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/data_average_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';

class Average extends BaseAverage<Data, Parameters> {
  Average({
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

  factory Average.fromJson(Map<String, dynamic> json, String id) {
    final param = Parameters.fromJson(json["parameters"]);

    return Average(
      id: id,
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      data: json["data"] == null
          ? null
          : param.sensor != null
              ? DataAverageSensor.fromJson(json["data"]) as Data
              : DataAverageAll.fromJson(json["data"]) as Data,
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
