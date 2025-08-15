class Alert {
  final String id;
  final String title;
  final String type;
  final String description;
  final String workspaceId;
  final DateTime createdAt;
  final bool isActive;

  Alert({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.workspaceId,
    required this.createdAt,
    required this.isActive,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      workspaceId: json['workspace_id'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'workspace_id': workspaceId,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  Alert copyWith({
    String? id,
    String? title,
    String? type,
    String? description,
    String? workspaceId,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Alert(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      workspaceId: workspaceId ?? this.workspaceId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
} 