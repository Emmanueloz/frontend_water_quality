import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_session.dart';
import 'package:frontend_water_quality/domain/models/ai/chat_response.dart';
import 'package:frontend_water_quality/domain/models/ai/session_response.dart';
import 'package:frontend_water_quality/domain/models/ai/session_metadata.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/ai_chat_repo.dart';
import 'package:frontend_water_quality/domain/repositories/auth_repo.dart';
import 'package:frontend_water_quality/domain/repositories/user_repo.dart';
import 'package:frontend_water_quality/presentation/providers/ai_chat_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class MockAiChatRepository implements AiChatRepository {
  Result<SessionResponse>? mockCreateSessionResult;
  Result<ChatResponse>? mockSendMessageResult;
  Result<ChatSession>? mockGetSessionResult;
  bool shouldThrowException = false;
  String? exceptionMessage;
  int callCount = 0;

  void reset() {
    mockCreateSessionResult = null;
    mockSendMessageResult = null;
    mockGetSessionResult = null;
    shouldThrowException = false;
    exceptionMessage = null;
    callCount = 0;
  }

  @override
  Future<Result<SessionResponse>> createSession(
      String analysisId, String token) async {
    callCount++;
    if (shouldThrowException) {
      throw Exception(exceptionMessage ?? 'Network error');
    }
    return mockCreateSessionResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<ChatResponse>> sendMessage(
      String analysisId, String message, String token) async {
    callCount++;
    if (shouldThrowException) {
      throw Exception(exceptionMessage ?? 'Network error');
    }
    return mockSendMessageResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<ChatSession>> getSession(
      String analysisId, String token) async {
    callCount++;
    if (shouldThrowException) {
      throw Exception(exceptionMessage ?? 'Network error');
    }
    return mockGetSessionResult ?? Result.failure('Mock not configured');
  }
}

class MockAuthProvider extends AuthProvider {
  User? _mockUser;
  String? _mockToken;
  bool _isAuthenticated = false;

  MockAuthProvider() : super(_MockAuthRepo(), _MockUserRepo());

  void setMockUser(User? user, String? token) {
    _mockUser = user;
    _mockToken = token;
    _isAuthenticated = user != null && token != null && token.isNotEmpty;
  }

  @override
  User? get user => _mockUser;

  @override
  String? get token => _mockToken;

  @override
  bool get isAuthenticated => _isAuthenticated;
}

class _MockAuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockUserRepo implements UserRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockConnectivityProvider {
  bool _isOnline = true;

  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;
}

void main() {
  group('AiChatProvider Tests', () {
    late MockAiChatRepository mockRepository;
    late MockAuthProvider mockAuthProvider;
    late MockConnectivityProvider mockConnectivityProvider;
    late AiChatProvider provider;

    setUp(() {
      mockRepository = MockAiChatRepository();
      mockAuthProvider = MockAuthProvider();
      mockConnectivityProvider = MockConnectivityProvider();
      provider = AiChatProvider(
          mockRepository, mockAuthProvider, mockConnectivityProvider);

      // Default to online status, but no authenticated user by default
      mockConnectivityProvider.setOnlineStatus(true);
    });

    tearDown(() {
      mockRepository.reset();
    });

    group('initializeSession', () {
      test('should return false when user is not authenticated', () async {
        // Act
        final result = await provider.initializeSession('analysis_1');

        // Assert
        expect(result, isFalse);
        expect(provider.errorMessage, contains('User not authenticated'));
      });
    });

    group('sendMessage', () {
      test('should return false when user is not authenticated', () async {
        // Act
        final result = await provider.sendMessage('Hello');

        // Assert
        expect(result, isFalse);
        expect(provider.errorMessage, contains('User not authenticated'));
      });

      test('should return false when no analysis is selected', () async {
        // Act
        final result = await provider.sendMessage('Hello');

        // Assert
        expect(result, isFalse);
        expect(provider.errorMessage, contains('User not authenticated'));
      });

      test('should return false for empty message', () async {
        // Act
        final result = await provider.sendMessage('   ');

        // Assert
        expect(result, isFalse);
        expect(provider.errorMessage, contains('User not authenticated'));
      });
    });

    group('loadSessionHistory', () {
      test('should return false when user is not authenticated', () async {
        // Act
        final result = await provider.loadSessionHistory();

        // Assert
        expect(result, isFalse);
        expect(provider.errorMessage, contains('User not authenticated'));
      });

      test('should return false when no analysis is selected', () async {
        // Act
        final result = await provider.loadSessionHistory();

        // Assert
        expect(result, isFalse);
        expect(provider.errorMessage, contains('User not authenticated'));
      });
    });

    group('state management', () {
      test('should clear session and reset state', () {
        // Act
        provider.clearSession();

        // Assert
        expect(provider.currentSession, isNull);
        expect(provider.currentAnalysisId, isNull);
        expect(provider.errorMessage, isNull);
        expect(provider.isLoading, isFalse);
        expect(provider.isInitializing, isFalse);
        expect(provider.isSendingMessage, isFalse);
      });

      test('should clear error message', () async {
        // Arrange - set error
        await provider.sendMessage(''); // This will set an error

        // Act
        provider.clearError();

        // Assert
        expect(provider.errorMessage, isNull);
      });

      test('should clean state when auth changes', () {
        // Act
        provider.clean();

        // Assert
        expect(provider.currentSession, isNull);
        expect(provider.currentAnalysisId, isNull);
      });
    });

    group('getters', () {
      test('should return correct state values', () {
        // Assert initial state
        expect(provider.hasSession, isFalse);
        expect(provider.messages, isEmpty);
        expect(provider.isLoading, isFalse);
        expect(provider.isInitializing, isFalse);
        expect(provider.isSendingMessage, isFalse);
        expect(provider.isRetrying, isFalse);
        expect(provider.isOffline, isFalse);
      });
    });

    group('Error Handling and Validation Tests', () {
      group('Input Validation', () {
        test('should reject empty message', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Act
          final result = await provider.sendMessage('');

          // Assert
          expect(result, isFalse);
          expect(provider.errorMessage, contains('Message cannot be empty'));
        });

        test('should reject whitespace-only message', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Act
          final result = await provider.sendMessage('   \n\t  ');

          // Assert
          expect(result, isFalse);
          expect(provider.errorMessage, contains('Message cannot be empty'));
        });

        test('should reject message exceeding character limit', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');
          final longMessage = 'a' * 4001; // Exceeds 4000 character limit

          // Act
          final result = await provider.sendMessage(longMessage);

          // Assert
          expect(result, isFalse);
          expect(
              provider.errorMessage, contains('cannot exceed 4000 characters'));
        });

        test('should sanitize message with control characters', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          mockRepository.mockSendMessageResult = Result.success(
              ChatResponse(response: 'AI response', sessionId: 'session_1'));
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Act
          final result = await provider.sendMessage('Hello\x00\x01World\x7F');

          // Assert
          expect(result, isTrue);
          // The message should be sanitized before sending
          expect(provider.messages.first.content, equals('HelloWorld'));
        });

        test('should handle message with excessive whitespace', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          mockRepository.mockSendMessageResult = Result.success(
              ChatResponse(response: 'AI response', sessionId: 'session_1'));
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Act
          final result = await provider
              .sendMessage('Hello          World\n\n\n\n\n\nTest');

          // Assert
          expect(result, isTrue);
          // The message should be sanitized
          expect(
              provider.messages.first.content, equals('Hello World\n\nTest'));
        });
      });

      group('Network Error Handling', () {
        test('should handle offline scenario', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          mockConnectivityProvider.setOnlineStatus(false);
          provider.setConnectivityProvider(mockConnectivityProvider);

          // Act
          final result = await provider.initializeSession('analysis_1');

          // Assert
          expect(result, isFalse);
          expect(provider.errorMessage, contains('No internet connection'));
        });

        test('should handle offline scenario during message sending', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');
          mockConnectivityProvider.setOnlineStatus(false);
          provider.setConnectivityProvider(mockConnectivityProvider);

          // Act
          final result = await provider.sendMessage('Hello');

          // Assert
          expect(result, isFalse);
          expect(provider.errorMessage, contains('No internet connection'));
        });

        test('should retry on network timeout errors', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Reset call count after initialization
          mockRepository.reset();
          mockRepository.mockSendMessageResult =
              Result.failure('connection timeout');

          // Act
          final result = await provider.sendMessage('Hello');

          // Assert
          expect(result, isFalse);
          expect(
              mockRepository.callCount, greaterThan(1)); // Should have retried
          expect(provider.errorMessage, contains('connection timeout'));
        });

        test('should retry on connection error', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          mockRepository.mockCreateSessionResult =
              Result.failure('connection error');

          // Act
          final result = await provider.initializeSession('analysis_1');

          // Assert
          expect(result, isFalse);
          expect(
              mockRepository.callCount, greaterThan(1)); // Should have retried
          expect(provider.errorMessage, contains('connection error'));
        });

        test('should not retry on authentication errors', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Reset call count after initialization
          mockRepository.reset();
          mockRepository.mockSendMessageResult =
              Result.failure('Authentication failed. Please log in again.');

          // Act
          final result = await provider.sendMessage('Hello');

          // Assert
          expect(result, isFalse);
          expect(mockRepository.callCount,
              equals(1)); // Should not retry auth errors
          expect(provider.errorMessage, contains('Authentication failed'));
        });

        test('should handle exception during network call', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          mockRepository.shouldThrowException = true;
          mockRepository.exceptionMessage = 'Network connection failed';

          // Act
          final result = await provider.initializeSession('analysis_1');

          // Assert
          expect(result, isFalse);
          expect(
              mockRepository.callCount, greaterThan(1)); // Should have retried
          expect(provider.errorMessage, contains('Network error'));
        });
      });

      group('API Error Responses', () {
        test('should handle 401 authentication error', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          mockRepository.mockCreateSessionResult =
              Result.failure('Authentication failed. Please log in again.');

          // Act
          final result = await provider.initializeSession('analysis_1');

          // Assert
          expect(result, isFalse);
          expect(provider.errorMessage, contains('Authentication failed'));
        });

        test('should handle 403 access denied error', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          mockRepository.mockSendMessageResult =
              Result.failure('Access denied to this analysis.');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Act
          final result = await provider.sendMessage('Hello');

          // Assert
          expect(result, isFalse);
          expect(provider.errorMessage, contains('Access denied'));
        });

        test('should handle 404 analysis not found error', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1'); // Set analysis ID
          mockRepository.mockGetSessionResult =
              Result.failure('Analysis not found or not available for chat.');

          // Act
          final result = await provider.loadSessionHistory();

          // Assert
          expect(result, isFalse);
          expect(provider.errorMessage, contains('Analysis not found'));
        });

        test('should handle 400 analysis not ready error', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          provider.setAuthProvider(mockAuthProvider);
          mockRepository.mockCreateSessionResult =
              Result.failure('Analysis must be completed before using chat.');

          // Act
          final result = await provider.initializeSession('analysis_1');

          // Assert
          expect(result, isFalse);
          expect(provider.errorMessage, contains('Analysis must be completed'));
        });
      });

      group('Retry Logic', () {
        test('should show retry state during retries', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          mockRepository.mockSendMessageResult =
              Result.failure('connection timeout');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Act
          final future = provider.sendMessage('Hello');

          // Give some time for retry to start
          await Future.delayed(Duration(milliseconds: 100));

          // Assert retry state is shown
          expect(provider.isRetrying, isTrue);

          // Wait for completion
          await future;
        });

        test('should reset retry state after successful operation', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          mockRepository.mockSendMessageResult = Result.success(
              ChatResponse(response: 'AI response', sessionId: 'session_1'));
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Act
          final result = await provider.sendMessage('Hello');

          // Assert
          expect(result, isTrue);
          expect(provider.isRetrying, isFalse);
        });

        test('should clear retry state when clearing session', () async {
          // Arrange
          mockRepository.mockSendMessageResult =
              Result.failure('connection timeout');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Start a failing operation
          provider.sendMessage('Hello');
          await Future.delayed(Duration(milliseconds: 100));

          // Act
          provider.clearSession();

          // Assert
          expect(provider.isRetrying, isFalse);
        });
      });

      group('Message State Management on Errors', () {
        test('should remove user message from UI when sending fails', () async {
          // Arrange
          mockRepository.mockSendMessageResult =
              Result.failure('Failed to send message');
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Act
          final result = await provider.sendMessage('Hello');

          // Assert
          expect(result, isFalse);
          expect(provider.messages, isEmpty); // User message should be removed
        });

        test('should keep user message when sending succeeds', () async {
          // Arrange
          mockAuthProvider.setMockUser(
              User(uid: 'test_user', email: 'test@example.com'), 'test_token');
          mockRepository.mockSendMessageResult = Result.success(
              ChatResponse(response: 'AI response', sessionId: 'session_1'));
          provider.setAuthProvider(mockAuthProvider);
          await provider.initializeSession('analysis_1');

          // Act
          final result = await provider.sendMessage('Hello');

          // Assert
          expect(result, isTrue);
          expect(provider.messages.length,
              equals(2)); // User message + AI response
          expect(provider.messages.first.content, equals('Hello'));
          expect(provider.messages.last.content, equals('AI response'));
        });
      });
    });
  });
}
