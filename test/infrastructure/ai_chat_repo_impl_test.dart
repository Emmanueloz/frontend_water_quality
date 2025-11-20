import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/ai_chat_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/ai/session_response.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_response.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_session.dart';
import '../utils/mock_dio.dart';

void main() {
  group('AiChatRepositoryImpl Tests', () {
    late MockDio mockDio;
    late AiChatRepositoryImpl repository;

    setUp(() {
      mockDio = MockDio();
      repository = AiChatRepositoryImpl(mockDio);
    });

    group('createSession', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'session_id': 'test_session_id',
          'context': 'Test context',
          'created_at': '2024-01-01T10:00:00Z',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.createSession('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<SessionResponse>());
        expect(result.value!.sessionId, equals('test_session_id'));
        expect(result.value!.context, equals('Test context'));
      });

      test('should return failure when API returns 401', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.createSession('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Authentication failed'));
      });

      test('should return failure when API returns 404', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {},
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.createSession('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Analysis not found'));
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.createSession('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Connection timeout'));
      });
    });

    group('sendMessage', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'response': 'AI response text',
          'session_id': 'test_session_id',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.sendMessage(
            'analysis_1', 'Hello AI', 'test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<ChatResponse>());
        expect(result.value!.response, equals('AI response text'));
        expect(result.value!.sessionId, equals('test_session_id'));
      });

      test('should return failure for empty message', () async {
        // Act
        final result =
            await repository.sendMessage('analysis_1', '', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Message cannot be empty'));
      });

      test('should return failure when API returns 403', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {},
          statusCode: 403,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.sendMessage('analysis_1', 'Hello', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Access denied'));
      });
    });

    group('getSession', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'session_id': 'test_session_id',
          'context': 'Test context',
          'created_at': '2024-01-01T10:00:00Z',
          'updated_at': '2024-01-01T11:00:00Z',
          'messages': [
            {
              'id': '1',
              'role': 'user',
              'content': 'Hello',
              'timestamp': '2024-01-01T10:30:00Z',
            },
            {
              'id': '2',
              'role': 'assistant',
              'content': 'Hi there!',
              'timestamp': '2024-01-01T10:31:00Z',
            }
          ],
          'metadata': {
            'analysis_id': 'analysis_1',
            'user_id': 'user_1',
            'workspace_id': 'workspace_1',
            'meter_id': 'meter_1',
            'analysis_type': 'correlation',
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getSession('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<ChatSession>());
        expect(result.value!.sessionId, equals('test_session_id'));
        expect(result.value!.messages.length, equals(2));
        expect(result.value!.metadata.analysisId, equals('analysis_1'));
      });

      test('should return failure when API returns 404', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {},
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getSession('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Chat session not found'));
      });

      test('should handle connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getSession('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Connection error'));
      });
    });
  });
}
