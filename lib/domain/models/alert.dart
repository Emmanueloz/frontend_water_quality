import 'package:frontend_water_quality/core/enums/alert_type.dart';

class Alert {
  final String? id;
  final String title;
  final AlertType type;
  final String workspaceId;
  final String? meterId;

  Alert({
    this.id,
    required this.title,
    required this.type,
    required this.workspaceId,
    this.meterId,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      title: json['title'] ?? '',
      type: json['type'] == null
          ? AlertType.good
          : AlertTypeExtension.fromName(json['type']),
      workspaceId: json['workspace_id'] ?? '',
      meterId: json['meter_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (meterId != null) data['meter_id'] = meterId;
    data['title'] = title;
    data['type'] = type.name;
    data['workspace_id'] = workspaceId;
    return data;
  }
}
