class ChatRequest {
  final String message;

  ChatRequest({
    required this.message,
  });

  ChatRequest copyWith({
    String? message,
  }) {
    return ChatRequest(
      message: message ?? this.message,
    );
  }

  factory ChatRequest.fromJson(Map<String, dynamic> json) {
    if (json['message'] == null) {
      throw ArgumentError('ChatRequest message cannot be null');
    }

    final message = json['message'].toString().trim();
    if (message.isEmpty) {
      throw ArgumentError('ChatRequest message cannot be empty');
    }

    return ChatRequest(
      message: _sanitizeMessage(message),
    );
  }

  /// Sanitizes message content for security
  static String _sanitizeMessage(String message) {
    // Remove null bytes and control characters (except newlines and tabs)
    String sanitized =
        message.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');

    // Limit consecutive whitespace
    sanitized = sanitized.replaceAll(RegExp(r'\s{10,}'), ' ');

    // Remove excessive newlines
    sanitized = sanitized.replaceAll(RegExp(r'\n{5,}'), '\n\n');

    return sanitized.trim();
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  /// Validates the message content
  bool get isValid {
    final trimmedMessage = message.trim();
    return trimmedMessage.isNotEmpty &&
        trimmedMessage.length <= 4000 &&
        trimmedMessage.isNotEmpty;
  }

  /// Returns validation error message if invalid, null if valid
  String? get validationError {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      return 'Message cannot be empty';
    }
    if (trimmedMessage.length > 4000) {
      return 'Message cannot exceed 4000 characters (current: ${trimmedMessage.length})';
    }
    if (trimmedMessage.isEmpty) {
      return 'Message is too short';
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatRequest && other.message == message;
  }

  @override
  int get hashCode {
    return message.hashCode;
  }

  @override
  String toString() {
    return 'ChatRequest(message: ${message.length} chars)';
  }
}
