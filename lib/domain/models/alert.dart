import 'package:frontend_water_quality/core/enums/alert_type.dart';

class Alert {
  final String? id;
  final String title;
  final AlertType type;
  final String workspaceId;
  final String? meterId;
  final Parameter ? parameters;
  final List<String>? sendToUsers;

  Alert({
    this.id,
    required this.title,
    required this.type,
    required this.workspaceId,
    this.meterId,
    this.parameters,
    this.sendToUsers,
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
      parameters: json['parameters'] != null
          ? Parameter.fromJson(json['parameters'])
          : null,
      sendToUsers: json['guests'] != null
          ? List<String>.from(json['guests'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (meterId != null) data['meter_id'] = meterId;
    data['title'] = title;
    data['type'] = type.name;
    data['workspace_id'] = workspaceId;
    if (parameters != null) data['parameters'] = parameters!.toJson();
    data['guests'] = sendToUsers ?? [];
    return data;
  }
}

class Parameter {
  final RangeValue ph;
  final RangeValue temperature;
  final RangeValue tds;
  final RangeValue conductivity;
  final RangeValue turbidity;
  

  Parameter({
    required this.ph,
    required this.temperature,
    required this.tds,
    required this.conductivity,
    required this.turbidity,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) {
    return Parameter(
      ph: RangeValue.fromJson(json['ph'] ?? {}),
      temperature: RangeValue.fromJson(json['temperature'] ?? {}),
      tds: RangeValue.fromJson(json['tds'] ?? {}),
      conductivity: RangeValue.fromJson(json['conductivity'] ?? {}),
      turbidity: RangeValue.fromJson(json['turbidity'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ph'] = ph.toJson();
    data['temperature'] = temperature.toJson();
    data['tds'] = tds.toJson();
    data['conductivity'] = conductivity.toJson();
    data['turbidity'] = turbidity.toJson();
    return data;
  }
}

class RangeValue {
  final double min;
  final double max;

  RangeValue({
    required this.min,
    required this.max,
  });

  factory RangeValue.fromJson(Map<String, dynamic> json) {
    return RangeValue(
      min: json['min'] ?? 0.0,
      max: json['max'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['min'] = min;
    data['max'] = max;
    return data;
  }
}
