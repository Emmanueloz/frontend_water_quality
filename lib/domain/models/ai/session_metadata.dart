class SessionMetadata {
  final String analysisId;
  final String userId;
  final String workspaceId;
  final String meterId;
  final String analysisType;

  SessionMetadata({
    required this.analysisId,
    required this.userId,
    required this.workspaceId,
    required this.meterId,
    required this.analysisType,
  });

  SessionMetadata copyWith({
    String? analysisId,
    String? userId,
    String? workspaceId,
    String? meterId,
    String? analysisType,
  }) {
    return SessionMetadata(
      analysisId: analysisId ?? this.analysisId,
      userId: userId ?? this.userId,
      workspaceId: workspaceId ?? this.workspaceId,
      meterId: meterId ?? this.meterId,
      analysisType: analysisType ?? this.analysisType,
    );
  }

  factory SessionMetadata.fromJson(Map<String, dynamic> json) {
    if (json['analysis_id'] == null || json['analysis_id'].toString().isEmpty) {
      throw ArgumentError('SessionMetadata analysis_id cannot be null or empty');
    }
    if (json['user_id'] == null || json['user_id'].toString().isEmpty) {
      throw ArgumentError('SessionMetadata user_id cannot be null or empty');
    }
    if (json['workspace_id'] == null || json['workspace_id'].toString().isEmpty) {
      throw ArgumentError('SessionMetadata workspace_id cannot be null or empty');
    }
    if (json['meter_id'] == null || json['meter_id'].toString().isEmpty) {
      throw ArgumentError('SessionMetadata meter_id cannot be null or empty');
    }
    if (json['analysis_type'] == null || json['analysis_type'].toString().isEmpty) {
      throw ArgumentError('SessionMetadata analysis_type cannot be null or empty');
    }

    return SessionMetadata(
      analysisId: json['analysis_id'].toString(),
      userId: json['user_id'].toString(),
      workspaceId: json['workspace_id'].toString(),
      meterId: json['meter_id'].toString(),
      analysisType: json['analysis_type'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analysis_id': analysisId,
      'user_id': userId,
      'workspace_id': workspaceId,
      'meter_id': meterId,
      'analysis_type': analysisType,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionMetadata &&
        other.analysisId == analysisId &&
        other.userId == userId &&
        other.workspaceId == workspaceId &&
        other.meterId == meterId &&
        other.analysisType == analysisType;
  }

  @override
  int get hashCode {
    return analysisId.hashCode ^
        userId.hashCode ^
        workspaceId.hashCode ^
        meterId.hashCode ^
        analysisType.hashCode;
  }

  @override
  String toString() {
    return 'SessionMetadata(analysisId: $analysisId, userId: $userId, workspaceId: $workspaceId, meterId: $meterId, analysisType: $analysisType)';
  }
}