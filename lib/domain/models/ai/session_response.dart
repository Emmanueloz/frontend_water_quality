class SessionResponse {
  final String sessionId;
  final String context;
  final String createdAt;

  SessionResponse({
    required this.sessionId,
    required this.context,
    required this.createdAt,
  });

  SessionResponse copyWith({
    String? sessionId,
    String? context,
    String? createdAt,
  }) {
    return SessionResponse(
      sessionId: sessionId ?? this.sessionId,
      context: context ?? this.context,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    if (json['session_id'] == null || json['session_id'].toString().isEmpty) {
      throw ArgumentError('SessionResponse session_id cannot be null or empty');
    }
    if (json['context'] == null) {
      throw ArgumentError('SessionResponse context cannot be null');
    }
    if (json['created_at'] == null || json['created_at'].toString().isEmpty) {
      throw ArgumentError('SessionResponse created_at cannot be null or empty');
    }

    return SessionResponse(
      sessionId: json['session_id'].toString(),
      context: json['context'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'context': context,
      'created_at': createdAt,
    };
  }

  /// Converts the created_at string to DateTime
  DateTime get createdAtDateTime {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      throw FormatException('Invalid created_at format: $createdAt');
    }
  }

  /// Checks if the session response has valid data
  bool get isValid {
    return sessionId.isNotEmpty && 
           context.isNotEmpty && 
           createdAt.isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionResponse &&
        other.sessionId == sessionId &&
        other.context == context &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return sessionId.hashCode ^ context.hashCode ^ createdAt.hashCode;
  }

  @override
  String toString() {
    return 'SessionResponse(sessionId: $sessionId, context: ${context.length} chars, createdAt: $createdAt)';
  }
}