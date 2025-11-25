import 'package:frontend_water_quality/core/enums/analysis_status.dart';
import 'package:frontend_water_quality/core/enums/analysis_type.dart';

class BaseAnalysis<TData, TParameters> {
  String? id;
  DateTime? createdAt;
  TData? data;
  String? error;
  String? meterId;
  TParameters? parameters;
  AnalysisStatus? status;
  AnalysisType? type;
  DateTime? updatedAt;
  String? workspaceId;

  BaseAnalysis({
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
}
