import 'package:frontend_water_quality/domain/models/analysis/base_analysis.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/data_correlation_matrix.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/param_correlation.dart';

class Correlation
    extends BaseAnalysis<DataCorrelationMatrix, ParamCorrelation> {
  Correlation({
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

  factory Correlation.fromJson(Map<String, dynamic> json, String id) {
    final param = ParamCorrelation.fromJson(json["parameters"]);

    return Correlation(
      id: id,
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      data: json["data"] == null
          ? null
          : DataCorrelationMatrix.fromJson(json["data"]),
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
