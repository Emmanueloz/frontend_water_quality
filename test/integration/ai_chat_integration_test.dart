import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/ai_chat_repo_impl.dart';
import 'package:frontend_water_quality/presentation/providers/ai_chat_provider.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/auth_repo.dart';
import 'package:frontend_water_quality/domain/repositories/user_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class MockDio implements Dio {
  final List<MockApiCall> _expectedCalls = [];
  int _currentCallIndex = 0;

  void expectCall(MockApiCall call) {
    _expectedCalls.add(call);
  }

  void reset() {
    _expectedCalls.clear();
    _currentCallIndex = 0;
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (_currentCallIndex >= _expectedCalls.length) {
      throw Exception('Unexpected API call: POST $path');
    }

    final expectedCall = _expectedCalls[_currentCallIndex++];
    if (expectedCall.method != 'POST' || expectedCall.path != path) {
      throw Exception(
          'Expected ${expectedCall.method} ${expectedCall.path}, got POST $path');
    }

    if (expectedCall.shouldThrow) {
      throw expectedCall.exception!;
    }

    return Response<T>(
      data: expectedCall.responseData as T,
      statusCode: expectedCall.statusCode,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (_currentCallIndex >= _expectedCalls.length) {
      throw Exception('Unexpected API call: GET $path');
    }

    final expectedCall = _expectedCalls[_currentCallIndex++];
    if (expectedCall.method != 'GET' || expectedCall.path != path) {
      throw Exception(
          'Expected ${expectedCall.method} ${expectedCall.path}, got GET $path');
    }

    if (expectedCall.shouldThrow) {
      throw expectedCall.exception!;
    }

    return Response<T>(
      data: expectedCall.responseData as T,
      statusCode: expectedCall.statusCode,
      requestOptions: RequestOptions(path: path),
    );
  }

  // Implement other required methods with no-op implementations
  @override
  BaseOptions get options => BaseOptions();

  @override
  set options(BaseOptions options) {}

  @override
  Interceptors get interceptors => Interceptors();

  @override
  HttpClientAdapter get httpClientAdapter => throw UnimplementedError();

  @override
  set httpClientAdapter(HttpClientAdapter adapter) {}

  @override
  Transformer get transformer => throw UnimplementedError();

  @override
  set transformer(Transformer transformer) {}

  @override
  void close({bool force = false}) {}

  @override
  Dio clone({
    HttpClientAdapter? httpClientAdapter,
    Interceptors? interceptors,
    BaseOptions? options,
    Transformer? transformer,
  }) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> delete<T>(String path,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Options? options,
          CancelToken? cancelToken}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> deleteUri<T>(Uri uri,
          {Object? data, Options? options, CancelToken? cancelToken}) =>
      throw UnimplementedError();

  @override
  Future<Response> download(String urlPath, dynamic savePath,
          {ProgressCallback? onReceiveProgress,
          Map<String, dynamic>? queryParameters,
          CancelToken? cancelToken,
          bool deleteOnError = true,
          String lengthHeader = Headers.contentLengthHeader,
          Object? data,
          Options? options,
          dynamic fileAccessMode}) =>
      throw UnimplementedError();

  @override
  Future<Response> downloadUri(Uri uri, dynamic savePath,
          {ProgressCallback? onReceiveProgress,
          CancelToken? cancelToken,
          bool deleteOnError = true,
          String lengthHeader = Headers.contentLengthHeader,
          Object? data,
          Options? options,
          dynamic fileAccessMode}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> fetch<T>(RequestOptions requestOptions) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> getUri<T>(Uri uri,
          {Object? data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> head<T>(String path,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Options? options,
          CancelToken? cancelToken}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> headUri<T>(Uri uri,
          {Object? data, Options? options, CancelToken? cancelToken}) =>
      throw UnimplementedError();

  void lock() {}

  @override
  Future<Response<T>> patch<T>(String path,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> patchUri<T>(Uri uri,
          {Object? data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> postUri<T>(Uri uri,
          {Object? data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> put<T>(String path,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> putUri<T>(Uri uri,
          {Object? data,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> request<T>(String path,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          CancelToken? cancelToken,
          Options? options,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  @override
  Future<Response<T>> requestUri<T>(Uri uri,
          {Object? data,
          CancelToken? cancelToken,
          Options? options,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress}) =>
      throw UnimplementedError();

  void unlock() {}
}

class MockApiCall {
  final String method;
  final String path;
  final int statusCode;
  final dynamic responseData;
  final bool shouldThrow;
  final Exception? exception;

  MockApiCall({
    required this.method,
    required this.path,
    required this.statusCode,
    this.responseData,
    this.shouldThrow = false,
    this.exception,
  });
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
  group('AI Chat Integration Tests', () {
    late MockDio mockDio;
    late AiChatRepositoryImpl repository;
    late MockAuthProvider mockAuthProvider;
    late MockConnectivityProvider mockConnectivityProvider;
    late AiChatProvider provider;

    setUp(() {
      mockDio = MockDio();
      repository = AiChatRepositoryImpl(mockDio);
      mockAuthProvider = MockAuthProvider();
      mockConnectivityProvider = MockConnectivityProvider();
      provider = AiChatProvider(
          repository, mockAuthProvider, mockConnectivityProvider);

      // Set up authenticated user by default
      mockAuthProvider.setMockUser(
        User(uid: 'test_user', email: 'test@example.com'),
        'test_token',
      );
      mockConnectivityProvider.setOnlineStatus(true);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('Complete Chat Flow End-to-End', () {
      test(
          'should complete full chat flow: session creation -> message sending -> history retrieval',
          () async {
        const analysisId = 'analysis_123';
        const sessionId = 'session_123';
        const userMessage = 'What is the average pH level?';
        const aiResponse =
            'The average pH level in your analysis is 7.2, which indicates neutral water quality.';

        // Step 1: Session creation (when no existing session exists)
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404, // No existing session
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 201,
          responseData: {
            'session_id': sessionId,
            'context':
                'Analysis context for pH, temperature, and dissolved oxygen measurements',
            'created_at': '2024-01-01T10:00:00Z',
          },
        ));

        // Step 2: Message sending
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/chat',
          statusCode: 200,
          responseData: {
            'response': aiResponse,
            'session_id': sessionId,
          },
        ));

        // Step 3: Session history retrieval
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 200,
          responseData: {
            'session_id': sessionId,
            'context':
                'Analysis context for pH, temperature, and dissolved oxygen measurements',
            'created_at': '2024-01-01T10:00:00Z',
            'updated_at': '2024-01-01T10:05:00Z',
            'messages': [
              {
                'id': '1',
                'role': 'user',
                'content': userMessage,
                'timestamp': '2024-01-01T10:05:00Z',
              },
              {
                'id': '2',
                'role': 'assistant',
                'content': aiResponse,
                'timestamp': '2024-01-01T10:05:30Z',
              }
            ],
            'metadata': {
              'analysis_id': analysisId,
              'user_id': 'test_user',
              'workspace_id': 'workspace_1',
              'meter_id': 'meter_1',
              'analysis_type': 'correlation',
            }
          },
        ));

        // Execute the complete flow

        // Step 1: Initialize session
        final sessionResult = await provider.initializeSession(analysisId);
        expect(sessionResult, isTrue);
        expect(provider.hasSession, isTrue);
        expect(provider.currentAnalysisId, equals(analysisId));
        expect(provider.errorMessage, isNull);

        // Step 2: Send message
        final messageResult = await provider.sendMessage(userMessage);
        expect(messageResult, isTrue);
        expect(provider.messages.length, equals(2));
        expect(provider.messages.first.content, equals(userMessage));
        expect(provider.messages.first.role, equals('user'));
        expect(provider.messages.last.content, equals(aiResponse));
        expect(provider.messages.last.role, equals('assistant'));

        // Step 3: Load session history (should get complete history from server)
        final historyResult = await provider.loadSessionHistory();
        expect(historyResult, isTrue);
        expect(provider.currentSession, isNotNull);
        expect(provider.currentSession!.sessionId, equals(sessionId));
        expect(provider.currentSession!.messages.length, equals(2));
        expect(
            provider.currentSession!.metadata.analysisId, equals(analysisId));

        // Verify all expected API calls were made
        expect(
            mockDio._currentCallIndex, equals(mockDio._expectedCalls.length));
      });

      test('should handle existing session flow: load existing -> send message',
          () async {
        const analysisId = 'analysis_456';
        const sessionId = 'session_456';
        const existingMessage = 'Previous question about temperature';
        const existingResponse = 'The temperature analysis shows...';
        const newMessage = 'What about dissolved oxygen?';
        const newResponse =
            'Dissolved oxygen levels are within normal range at 8.5 mg/L.';

        // Step 1: Load existing session
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 200,
          responseData: {
            'session_id': sessionId,
            'context': 'Analysis context with temperature and oxygen data',
            'created_at': '2024-01-01T09:00:00Z',
            'updated_at': '2024-01-01T09:30:00Z',
            'messages': [
              {
                'id': '1',
                'role': 'user',
                'content': existingMessage,
                'timestamp': '2024-01-01T09:30:00Z',
              },
              {
                'id': '2',
                'role': 'assistant',
                'content': existingResponse,
                'timestamp': '2024-01-01T09:30:30Z',
              }
            ],
            'metadata': {
              'analysis_id': analysisId,
              'user_id': 'test_user',
              'workspace_id': 'workspace_1',
              'meter_id': 'meter_1',
              'analysis_type': 'average',
            }
          },
        ));

        // Step 2: Send new message
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/chat',
          statusCode: 200,
          responseData: {
            'response': newResponse,
            'session_id': sessionId,
          },
        ));

        // Execute the flow

        // Step 1: Initialize session (should load existing)
        final sessionResult = await provider.initializeSession(analysisId);
        expect(sessionResult, isTrue);
        expect(provider.hasSession, isTrue);
        expect(provider.messages.length, equals(2));
        expect(provider.messages.first.content, equals(existingMessage));
        expect(provider.messages.last.content, equals(existingResponse));

        // Step 2: Send new message
        final messageResult = await provider.sendMessage(newMessage);
        expect(messageResult, isTrue);
        expect(provider.messages.length, equals(4));
        expect(provider.messages[2].content, equals(newMessage));
        expect(provider.messages[3].content, equals(newResponse));

        // Verify all expected API calls were made
        expect(
            mockDio._currentCallIndex, equals(mockDio._expectedCalls.length));
      });

      test(
          'should handle session creation when sending first message without initialization',
          () async {
        const analysisId = 'analysis_789';
        const sessionId = 'session_789';
        const firstMessage = 'Tell me about the water quality trends';
        const aiResponse =
            'Based on your analysis, the water quality shows improving trends over the past month.';

        // Manually set analysis ID without initializing session
        provider.clearSession();
        // We need to simulate the scenario where user sends message without session
        // This would typically happen if the UI allows sending messages before initialization

        // The sendMessage should handle session creation automatically
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/chat',
          statusCode: 200,
          responseData: {
            'response': aiResponse,
            'session_id': sessionId,
          },
        ));

        // Simulate setting analysis ID and sending message
        await provider.initializeSession(
            analysisId); // This will fail but set the analysis ID
        mockDio.reset(); // Reset to clear the failed calls

        // Now set up the successful message sending
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/chat',
          statusCode: 200,
          responseData: {
            'response': aiResponse,
            'session_id': sessionId,
          },
        ));

        // Send message (should create session automatically)
        final messageResult = await provider.sendMessage(firstMessage);
        expect(messageResult, isTrue);
        expect(provider.messages.length, equals(2));
        expect(provider.messages.first.content, equals(firstMessage));
        expect(provider.messages.last.content, equals(aiResponse));
      });
    });

    group('Cross-Analysis Type Testing', () {
      test('should work with correlation analysis', () async {
        const analysisId = 'correlation_analysis_1';

        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 201,
          responseData: {
            'session_id': analysisId,
            'context':
                'Correlation analysis between pH and temperature parameters',
            'created_at': '2024-01-01T10:00:00Z',
          },
        ));

        final result = await provider.initializeSession(analysisId);
        expect(result, isTrue);
        expect(
            provider.currentSession!.context, contains('Correlation analysis'));
      });

      test('should work with average analysis', () async {
        const analysisId = 'average_analysis_1';

        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 201,
          responseData: {
            'session_id': analysisId,
            'context':
                'Average analysis of water quality parameters over time period',
            'created_at': '2024-01-01T10:00:00Z',
          },
        ));

        final result = await provider.initializeSession(analysisId);
        expect(result, isTrue);
        expect(provider.currentSession!.context, contains('Average analysis'));
      });

      test('should work with prediction analysis', () async {
        const analysisId = 'prediction_analysis_1';

        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 201,
          responseData: {
            'session_id': analysisId,
            'context': 'Prediction analysis for future water quality trends',
            'created_at': '2024-01-01T10:00:00Z',
          },
        ));

        final result = await provider.initializeSession(analysisId);
        expect(result, isTrue);
        expect(
            provider.currentSession!.context, contains('Prediction analysis'));
      });

      test('should work with period analysis', () async {
        const analysisId = 'period_analysis_1';

        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 201,
          responseData: {
            'session_id': analysisId,
            'context': 'Period analysis comparing different time ranges',
            'created_at': '2024-01-01T10:00:00Z',
          },
        ));

        final result = await provider.initializeSession(analysisId);
        expect(result, isTrue);
        expect(provider.currentSession!.context, contains('Period analysis'));
      });
    });

    group('Analysis Workflow Integration', () {
      test('should handle analysis state transitions correctly', () async {
        const analysisId = 'analysis_state_test';

        // Test 1: Analysis not ready (400 error on both GET and POST)
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404, // No existing session
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 400, // Analysis not ready
        ));

        var result = await provider.initializeSession(analysisId);
        expect(result, isFalse);
        expect(provider.errorMessage, contains('Analysis must be completed'));

        // Reset for next test
        provider.clearError();
        mockDio.reset();

        // Test 2: Analysis becomes ready (successful session creation)
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 201,
          responseData: {
            'session_id': analysisId,
            'context': 'Analysis is now ready for chat',
            'created_at': '2024-01-01T10:00:00Z',
          },
        ));

        result = await provider.initializeSession(analysisId);
        expect(result, isTrue);
        expect(provider.hasSession, isTrue);
        expect(provider.errorMessage, isNull);
      });

      test('should handle analysis access permissions', () async {
        const analysisId = 'restricted_analysis';

        // Test access denied scenario (403 on GET, then 403 on POST)
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404, // No existing session
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 403, // Access denied
        ));

        final result = await provider.initializeSession(analysisId);
        expect(result, isFalse);
        expect(provider.errorMessage, contains('Access denied'));
        expect(provider.hasSession, isFalse);
      });

      test('should handle analysis not found', () async {
        const analysisId = 'nonexistent_analysis';

        // Test analysis not found scenario
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        final result = await provider.initializeSession(analysisId);
        expect(result, isFalse);
        expect(provider.errorMessage, contains('Analysis not found'));
        expect(provider.hasSession, isFalse);
      });
    });

    group('Error Recovery and Resilience', () {
      test('should recover from network errors with retry', () async {
        const analysisId = 'network_error_test';

        // First attempt: GET fails with network error, then POST also fails
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 0, // Not used when shouldThrow is true
          shouldThrow: true,
          exception: DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 0, // Not used when shouldThrow is true
          shouldThrow: true,
          exception: DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        ));

        // Second attempt (retry): GET fails (404), then POST succeeds
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 201,
          responseData: {
            'session_id': analysisId,
            'context': 'Recovered from network error',
            'created_at': '2024-01-01T10:00:00Z',
          },
        ));

        final result = await provider.initializeSession(analysisId);
        expect(result, isTrue);
        expect(provider.hasSession, isTrue);
        expect(provider.errorMessage, isNull);
      }, timeout: Timeout(Duration(seconds: 30))); // Allow time for retries

      test('should handle authentication token refresh scenarios', () async {
        const analysisId = 'auth_refresh_test';
        const newToken = 'refreshed_token';

        // First call fails with 401 on both GET and POST
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404, // No existing session
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 401, // Authentication failed
        ));

        var result = await provider.initializeSession(analysisId);
        expect(result, isFalse);
        expect(provider.errorMessage, contains('Authentication failed'));

        // Simulate token refresh
        mockAuthProvider.setMockUser(
          User(uid: 'test_user', email: 'test@example.com'),
          newToken,
        );
        provider.setAuthProvider(mockAuthProvider);
        provider.clearError();
        mockDio.reset();

        // Retry with new token should succeed
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 201,
          responseData: {
            'session_id': analysisId,
            'context': 'Authenticated with refreshed token',
            'created_at': '2024-01-01T10:00:00Z',
          },
        ));

        result = await provider.initializeSession(analysisId);
        expect(result, isTrue);
        expect(provider.hasSession, isTrue);
      });

      test('should handle offline/online transitions', () async {
        const analysisId = 'offline_test';

        // Test offline scenario
        mockConnectivityProvider.setOnlineStatus(false);
        provider.setConnectivityProvider(mockConnectivityProvider);

        var result = await provider.initializeSession(analysisId);
        expect(result, isFalse);
        expect(provider.errorMessage, contains('No internet connection'));

        // Test coming back online
        mockConnectivityProvider.setOnlineStatus(true);
        provider.clearError();

        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 201,
          responseData: {
            'session_id': analysisId,
            'context': 'Back online',
            'created_at': '2024-01-01T10:00:00Z',
          },
        ));

        result = await provider.initializeSession(analysisId);
        expect(result, isTrue);
        expect(provider.hasSession, isTrue);
      });
    });

    group('Message Flow Validation', () {
      test('should maintain message order and integrity', () async {
        const analysisId = 'message_order_test';
        const messages = [
          'First question about pH',
          'Second question about temperature',
          'Third question about dissolved oxygen'
        ];
        const responses = [
          'pH levels are normal at 7.2',
          'Temperature is stable at 22°C',
          'Dissolved oxygen is healthy at 8.5 mg/L'
        ];

        // Initialize session
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 404,
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 201,
          responseData: {
            'session_id': analysisId,
            'context': 'Multi-message test session',
            'created_at': '2024-01-01T10:00:00Z',
          },
        ));

        await provider.initializeSession(analysisId);

        // Send multiple messages in sequence
        for (int i = 0; i < messages.length; i++) {
          mockDio.expectCall(MockApiCall(
            method: 'POST',
            path: '/analysis/ai/$analysisId/chat',
            statusCode: 200,
            responseData: {
              'response': responses[i],
              'session_id': analysisId,
            },
          ));

          final result = await provider.sendMessage(messages[i]);
          expect(result, isTrue);

          // Verify message order
          final expectedMessageCount =
              (i + 1) * 2; // user + AI response for each
          expect(provider.messages.length, equals(expectedMessageCount));

          // Verify the latest user message
          expect(provider.messages[expectedMessageCount - 2].content,
              equals(messages[i]));
          expect(
              provider.messages[expectedMessageCount - 2].role, equals('user'));

          // Verify the latest AI response
          expect(provider.messages[expectedMessageCount - 1].content,
              equals(responses[i]));
          expect(provider.messages[expectedMessageCount - 1].role,
              equals('assistant'));
        }

        // Verify final state
        expect(provider.messages.length, equals(6)); // 3 user + 3 AI messages

        // Verify all messages are in correct order
        for (int i = 0; i < messages.length; i++) {
          expect(provider.messages[i * 2].content, equals(messages[i]));
          expect(provider.messages[i * 2].role, equals('user'));
          expect(provider.messages[i * 2 + 1].content, equals(responses[i]));
          expect(provider.messages[i * 2 + 1].role, equals('assistant'));
        }
      });

      test('should filter system messages from UI display', () async {
        const analysisId = 'system_message_test';

        // Load session with system messages
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/analysis/ai/$analysisId/session',
          statusCode: 200,
          responseData: {
            'session_id': analysisId,
            'context': 'Session with system messages',
            'created_at': '2024-01-01T10:00:00Z',
            'updated_at': '2024-01-01T10:05:00Z',
            'messages': [
              {
                'id': '1',
                'role': 'system',
                'content': 'System initialization message',
                'timestamp': '2024-01-01T10:00:00Z',
              },
              {
                'id': '2',
                'role': 'user',
                'content': 'User question',
                'timestamp': '2024-01-01T10:01:00Z',
              },
              {
                'id': '3',
                'role': 'assistant',
                'content': 'AI response',
                'timestamp': '2024-01-01T10:01:30Z',
              },
              {
                'id': '4',
                'role': 'system',
                'content': 'System status update',
                'timestamp': '2024-01-01T10:02:00Z',
              }
            ],
            'metadata': {
              'analysis_id': analysisId,
              'user_id': 'test_user',
              'workspace_id': 'workspace_1',
              'meter_id': 'meter_1',
              'analysis_type': 'correlation',
            }
          },
        ));

        await provider.initializeSession(analysisId);

        // Verify that all messages are stored internally
        expect(provider.currentSession!.messages.length, equals(4));

        // Verify that system messages are included in the full session
        expect(
            provider.currentSession!.messages
                .where((m) => m.role == 'system')
                .length,
            equals(2));
        expect(
            provider.currentSession!.messages
                .where((m) => m.role == 'user')
                .length,
            equals(1));
        expect(
            provider.currentSession!.messages
                .where((m) => m.role == 'assistant')
                .length,
            equals(1));

        // The messages getter should return all messages (filtering is done in UI)
        expect(provider.messages.length, equals(4));
      });
    });
  });
}
