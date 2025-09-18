import 'package:frontend_water_quality/domain/models/analysis/data.dart';
import 'package:frontend_water_quality/domain/models/analysis/data_average_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/data_average_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';

class Average {
  String? id;
  DateTime? createdAt;
  Data? data;
  String? error;
  String? meterId;
  Parameters? parameters;
  String? status;
  String? type;
  DateTime? updatedAt;
  String? workspaceId;

  Average({
    this.id,
    this.createdAt,
    this.data,
    this.error,
    this.meterId,
    this.parameters,
    this.status,
    this.type,
    this.updatedAt,
    this.workspaceId,
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
              ? DataAverageSensor.fromJson(json["data"])
              : DataAverageAll.fromJson(json["data"]),
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

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "data": data?.toJson(),
        "error": error,
        "meter_id": meterId,
        "parameters": parameters?.toJson(),
        "status": status,
        "type": type,
        "updated_at": updatedAt?.toIso8601String(),
        "workspace_id": workspaceId,
      };
}
