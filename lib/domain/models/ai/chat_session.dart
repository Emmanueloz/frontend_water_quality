import 'package:frontend_water_quality/domain/models/ai/chat_message.dart';
import 'package:frontend_water_quality/domain/models/ai/session_metadata.dart';

class ChatSession {
  final String sessionId;
  final String context;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<ChatMessage> messages;
  final SessionMetadata metadata;

  ChatSession({
    required this.sessionId,
    required this.context,
    required this.createdAt,
    this.updatedAt,
    required this.messages,
    required this.metadata,
  });

  ChatSession copyWith({
    String? sessionId,
    String? context,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ChatMessage>? messages,
    SessionMetadata? metadata,
  }) {
    return ChatSession(
      sessionId: sessionId ?? this.sessionId,
      context: context ?? this.context,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      metadata: metadata ?? this.metadata,
    );
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    if (json['session_id'] == null || json['session_id'].toString().isEmpty) {
      throw ArgumentError('ChatSession session_id cannot be null or empty');
    }
    if (json['context'] == null) {
      throw ArgumentError('ChatSession context cannot be null');
    }
    if (json['metadata'] == null) {
      throw ArgumentError('ChatSession metadata cannot be null');
    }

    return ChatSession(
      sessionId: json['session_id'].toString(),
      context: json['context'].toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : null,
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((messageJson) => ChatMessage.fromJson(messageJson))
              .toList()
          : [],
      metadata: SessionMetadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'context': context,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'messages': messages.map((message) => message.toJson()).toList(),
      'metadata': metadata.toJson(),
    };
  }

  /// Adds a new message to the session and returns a new ChatSession instance
  ChatSession addMessage(ChatMessage message) {
    final updatedMessages = List<ChatMessage>.from(messages)..add(message);
    return copyWith(
      messages: updatedMessages,
      updatedAt: DateTime.now(),
    );
  }

  /// Returns the latest message in the session, or null if no messages exist
  ChatMessage? get latestMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }

  /// Returns only user and assistant messages (filters out system messages)
  List<ChatMessage> get displayableMessages {
    return messages.where((message) => message.role != 'system').toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatSession &&
        other.sessionId == sessionId &&
        other.context == context &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.messages.length == messages.length &&
        other.metadata == metadata;
  }

  @override
  int get hashCode {
    return sessionId.hashCode ^
        context.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        messages.length.hashCode ^
        metadata.hashCode;
  }

  @override
  String toString() {
    return 'ChatSession(sessionId: $sessionId, context: ${context.length} chars, createdAt: $createdAt, updatedAt: $updatedAt, messages: ${messages.length}, metadata: $metadata)';
  }
}
