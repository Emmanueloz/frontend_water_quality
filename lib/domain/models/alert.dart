import 'package:frontend_water_quality/core/enums/alert_type.dart';

class Alert {
  final String id;
  final String title;
  final AlertType type;
  final String workspaceId;
  final String? meterId;
  final bool isActive;

  Alert({
    required this.id,
    required this.title,
    required this.type,
    required this.workspaceId,
    this.meterId,
    required this.isActive,
  });

  factory Alert.fromJson(List<dynamic> json) {
    return Alert(
      id: json[0] ?? '',
      title: json[1] ?? '',
      type: json[2] == null 
          ? AlertType.good 
          : AlertTypeExtension.fromName(json[2]),
      workspaceId: json[3] ?? '',
      meterId: json[4],
      isActive: json[5] ?? true,
    );
  }

  List<dynamic> toJson() {
    final list = [
      id,
      title,
      type.name,
      workspaceId,
      meterId,
      isActive,
    ];

    return list;
  }

  Alert copyWith({
    String? id,
    String? title,
    AlertType? type,
    String? workspaceId,
    String? meterId,
    bool? isActive,
  }) {
    return Alert(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      workspaceId: workspaceId ?? this.workspaceId,
      meterId: meterId ?? this.meterId,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'Alert(id: $id, title: $title, type: $type, workspaceId: $workspaceId, meterId: $meterId, isActive: $isActive)';
  }
} 