import 'package:frontend_water_quality/core/enums/alert_type.dart';

class Alert {
  final String id;
  final String title;
  final AlertType type;
  final String workspaceId;
  final DateTime createdAt;
  final bool isActive;

  Alert({
    required this.id,
    required this.title,
    required this.type,
    required this.workspaceId,
    required this.createdAt,
    required this.isActive,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] == null 
          ? AlertType.good 
          : AlertTypeExtension.fromName(json['type']),
      workspaceId: json['workspace_id'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'title': title,
      'type': type.name,
      'workspace_id': workspaceId,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };

    return json;
  }

  Alert copyWith({
    String? id,
    String? title,
    AlertType? type,
    String? workspaceId,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Alert(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      workspaceId: workspaceId ?? this.workspaceId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
} 