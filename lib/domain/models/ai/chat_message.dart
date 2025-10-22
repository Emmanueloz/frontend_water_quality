class ChatMessage {
  final String id;
  final String role; // 'user', 'assistant' or 'system'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  ChatMessage copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['id'].toString().isEmpty) {
      throw ArgumentError('ChatMessage id cannot be null or empty');
    }
    if (json['role'] == null || json['role'].toString().isEmpty) {
      throw ArgumentError('ChatMessage role cannot be null or empty');
    }
    if (json['content'] == null) {
      throw ArgumentError('ChatMessage content cannot be null');
    }

    final validRoles = ['user', 'assistant', 'system'];
    final role = json['role'].toString();
    if (!validRoles.contains(role)) {
      throw ArgumentError('Invalid role: $role. Must be one of: ${validRoles.join(', ')}');
    }

    return ChatMessage(
      id: json['id'].toString(),
      role: role,
      content: json['content'].toString(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage &&
        other.id == id &&
        other.role == role &&
        other.content == content &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^ role.hashCode ^ content.hashCode ^ timestamp.hashCode;
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, timestamp: $timestamp)';
  }
}