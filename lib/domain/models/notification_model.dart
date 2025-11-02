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
    required this.userIds,
    required this.date,
    required this.status ,
    this.aprovedBy,
    required this.recordParameters,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      read: json['read'] == 'true',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userIds: json['user_ids'] ?? '',
      date: DateTime.parse(json['date']),
      status: json['status'] ?? '',
      aprovedBy: json['aproved_by'],
      recordParameters: json['record_parameters'] != null
          ? List<RecordParameter>.from(
              json['record_parameters']
                  .map((x) => RecordParameter.fromJson(x)))
          : [], 
    );
  }
}

class RecordParameter{
  final String parameter;
  final String value;

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
