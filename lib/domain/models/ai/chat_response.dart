class ChatResponse {
  final String response;
  final String sessionId;

  ChatResponse({
    required this.response,
    required this.sessionId,
  });

  ChatResponse copyWith({
    String? response,
    String? sessionId,
  }) {
    return ChatResponse(
      response: response ?? this.response,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    if (json['response'] == null) {
      throw ArgumentError('ChatResponse response cannot be null');
    }
    if (json['session_id'] == null || json['session_id'].toString().isEmpty) {
      throw ArgumentError('ChatResponse session_id cannot be null or empty');
    }

    return ChatResponse(
      response: json['response'].toString(),
      sessionId: json['session_id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'session_id': sessionId,
    };
  }

  /// Checks if the response contains valid content
  bool get hasValidResponse {
    return response.trim().isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatResponse &&
        other.response == response &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    return response.hashCode ^ sessionId.hashCode;
  }

  @override
  String toString() {
    return 'ChatResponse(response: ${response.length} chars, sessionId: $sessionId)';
  }
}