class BaseAnalysis<TData, TParameters> {
  String? id;
  DateTime? createdAt;
  TData? data;
  String? error;
  String? meterId;
  TParameters? parameters;
  String? status;
  String? type;
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

  factory BaseAnalysis.fromJson(
    Map<String, dynamic> json,
    String id,
    TData Function(Map<String, dynamic>) dataFromJson,
    TParameters Function(Map<String, dynamic>) parametersFromJson,
  ) {
    return BaseAnalysis<TData, TParameters>(
      id: id,
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      data: json["data"] == null ? null : dataFromJson(json["data"]),
      error: json["error"],
      meterId: json["meter_id"],
      parameters: json["parameters"] == null
          ? null
          : parametersFromJson(json["parameters"]),
      status: json["status"],
      type: json["type"],
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      workspaceId: json["workspace_id"],
    );
  }
}
