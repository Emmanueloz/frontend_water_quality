class NotificationModel {
  final String id;
  final bool read;
  final String title;
  final String body;
  final String userId;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.read,
    required this.title,
    required this.body,
    required this.userId,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      read: json['read'] == 'true',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['user_id'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }
}
