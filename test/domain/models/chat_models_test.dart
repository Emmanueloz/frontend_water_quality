import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_message.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_request.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_session.dart';
import 'package:frontend_water_quality/domain/models/ai/session_metadata.dart';

void main() {
  group('Chat Models Tests', () {
    test('ChatMessage serialization and validation', () {
      final message = ChatMessage(
        id: '1',
        role: 'user',
        content: 'Hello AI',
        timestamp: DateTime.parse('2024-01-01T10:00:00Z'),
      );

      final json = message.toJson();
      final fromJson = ChatMessage.fromJson(json);

      expect(fromJson.id, equals('1'));
      expect(fromJson.role, equals('user'));
      expect(fromJson.content, equals('Hello AI'));
      expect(
          fromJson.timestamp, equals(DateTime.parse('2024-01-01T10:00:00Z')));
    });

    test('ChatRequest validation', () {
      final request = ChatRequest(message: 'Test message');
      expect(request.isValid, isTrue);
      expect(request.validationError, isNull);

      final emptyRequest = ChatRequest(message: '');
      expect(emptyRequest.isValid, isFalse);
      expect(emptyRequest.validationError, isNotNull);
    });

    test('SessionMetadata serialization', () {
      final metadata = SessionMetadata(
        analysisId: 'analysis_1',
        userId: 'user_1',
        workspaceId: 'workspace_1',
        meterId: 'meter_1',
        analysisType: 'correlation',
      );

      final json = metadata.toJson();
      final fromJson = SessionMetadata.fromJson(json);

      expect(fromJson.analysisId, equals('analysis_1'));
      expect(fromJson.userId, equals('user_1'));
      expect(fromJson.workspaceId, equals('workspace_1'));
      expect(fromJson.meterId, equals('meter_1'));
      expect(fromJson.analysisType, equals('correlation'));
    });

    test('ChatSession with messages', () {
      final metadata = SessionMetadata(
        analysisId: 'analysis_1',
        userId: 'user_1',
        workspaceId: 'workspace_1',
        meterId: 'meter_1',
        analysisType: 'correlation',
      );

      final message = ChatMessage(
        id: '1',
        role: 'user',
        content: 'Hello',
        timestamp: DateTime.now(),
      );

      final session = ChatSession(
        sessionId: 'session_1',
        context: 'Analysis context',
        createdAt: DateTime.now(),
        messages: [message],
        metadata: metadata,
      );

      expect(session.latestMessage, equals(message));
      expect(session.displayableMessages.length, equals(1));

      final newMessage = ChatMessage(
        id: '2',
        role: 'assistant',
        content: 'Hi there!',
        timestamp: DateTime.now(),
      );

      final updatedSession = session.addMessage(newMessage);
      expect(updatedSession.messages.length, equals(2));
      expect(updatedSession.latestMessage, equals(newMessage));
    });
  });
}
