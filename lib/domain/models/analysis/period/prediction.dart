import 'package:frontend_water_quality/core/enums/analysis_status.dart';
import 'package:frontend_water_quality/core/enums/analysis_type.dart';
import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:frontend_water_quality/domain/models/analysis/data.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/data_pred_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/data_pred_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/param_prediction.dart';

class PredictionSensor extends BaseAnalysis<Data, ParamPrediction> {
  PredictionSensor({
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

  factory PredictionSensor.fromJson(Map<String, dynamic> json, String id) {
    final param = ParamPrediction.fromJson(json["parameters"]);

    return PredictionSensor(
      id: id,
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      data: json["data"] == null
          ? null
          : param.sensor != null
              ? DataPredSensor.fromJson(json["data"])
              : DataPredAll.fromJson(json["data"]),
      error: json["error"],
      meterId: json["meter_id"],
      parameters: json["parameters"] == null ? null : param,
      status: json["status"] == null
          ? null
          : AnalysisStatusExtension.fromString(json["status"]),
      type: json["type"] == null
          ? null
          : AnalysisTypeExtension.fromString(json["type"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      workspaceId: json["workspace_id"],
    );
  }
}
