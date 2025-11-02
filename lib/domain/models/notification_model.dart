class NotificationModel {
  final String id;
  final bool read;
  final String title;
  final String body;
  final List<String>? userIds;
  final DateTime date;
  final String status;
  final String? aprovedBy;
  final List<RecordParameter> recordParameters;

  NotificationModel({
    required this.id,
    required this.read,
    required this.title,
    required this.body,
    this.userIds,
    required this.date,
    required this.status,
    this.aprovedBy,
    required this.recordParameters,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Conversión segura de user_ids -> List<String>
    final userIdsList = (json['user_ids'] as List<dynamic>?)
            ?.map((e) => e?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        <String>[];

    // record_parameters -> List<RecordParameter> (asegurando Map<String,dynamic>)
    final rp = (json['record_parameters'] as List?)
            ?.map((item) => RecordParameter.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList() ??
        <RecordParameter>[];
    return NotificationModel(
      id: json['id'] ?? '',
      read: json['read'] == true,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userIds: userIdsList,
      date: DateTime.parse(json['datetime']),
      status: json['status'] ?? '',
      aprovedBy: json['aproved_by'],
      recordParameters: rp,
    );
  }
}

class RecordParameter {
  final String parameter;
  final double value;

  RecordParameter({
    required this.parameter,
    required this.value,
  });

  factory RecordParameter.fromJson(Map<String, dynamic> json) {
    return RecordParameter(
      parameter: json['parameter'] ?? '',
      value: json['value'] ?? '',
    );
  }
}
