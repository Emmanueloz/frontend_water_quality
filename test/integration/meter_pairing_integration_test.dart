import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/meter_repo_impl.dart';

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
  Future<Response<T>> get<T>(String path,
          {Object? data,
          Map<String, dynamic>? queryParameters,
          Options? options,
          CancelToken? cancelToken,
          ProgressCallback? onReceiveProgress}) =>
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

// Simple Bluetooth command simulator
class BluetoothCommandSimulator {
  final List<String> _transmittedCommands = [];
  bool _isConnected = false;
  bool _shouldFailTransmission = false;

  void setConnected(bool connected) {
    _isConnected = connected;
  }

  void setShouldFailTransmission(bool shouldFail) {
    _shouldFailTransmission = shouldFail;
  }

  List<String> get transmittedCommands => _transmittedCommands;

  void clearTransmittedCommands() {
    _transmittedCommands.clear();
  }

  Future<bool> transmitCommand(String command) async {
    if (!_isConnected) {
      return false;
    }

    await Future.delayed(
        Duration(milliseconds: 50)); // Simulate transmission delay

    if (_shouldFailTransmission) {
      return false;
    }

    _transmittedCommands.add(command);
    return true;
  }
}

void main() {
  group('Meter Pairing Integration Tests', () {
    late MockDio mockDio;
    late MeterRepoImpl meterRepository;
    late BluetoothCommandSimulator bluetoothSimulator;

    setUp(() {
      mockDio = MockDio();
      meterRepository = MeterRepoImpl(mockDio);
      bluetoothSimulator = BluetoothCommandSimulator();
    });

    tearDown(() {
      mockDio.reset();
      bluetoothSimulator.clearTransmittedCommands();
    });

    // Helper method to simulate complete pairing flow
    Future<bool> simulateCompletePairingFlow(
        String workspaceId, String meterId) async {
      // Step 1: Call API to get new token
      final pairingResult =
          await meterRepository.pairMeter('user_token', workspaceId, meterId);

      if (!pairingResult.isSuccess) {
        return false;
      }

      // Step 2: Transmit token via Bluetooth
      final transmissionResult = await bluetoothSimulator
          .transmitCommand('setApiKey=${pairingResult.value!.token}');

      return transmissionResult;
    }

    // Helper method to simulate token validation flow
    Future<bool> simulateTokenValidationFlow(
        String workspaceId, String meterId, String deviceToken) async {
      final validationResult = await meterRepository.validateToken(
          'user_token', workspaceId, meterId, deviceToken);

      return validationResult.isSuccess && validationResult.value!;
    }

    group('End-to-End Pairing Flow', () {
      test(
          'should complete full pairing flow: API call -> Bluetooth transmission',
          () async {
        const workspaceId = 'workspace_1';
        const meterId = 'meter_1';
        const newToken = 'new_device_token_123';

        // Set up connected Bluetooth state
        bluetoothSimulator.setConnected(true);

        // Set up API response for pairing
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/$workspaceId/pair/$meterId/',
          statusCode: 200,
          responseData: {
            'message': 'Meter paired successfully',
            'token': newToken,
          },
        ));

        // Execute complete pairing flow
        final success = await simulateCompletePairingFlow(workspaceId, meterId);

        // Verify success
        expect(success, isTrue);

        // Verify API was called
        expect(mockDio._currentCallIndex, equals(1));

        // Verify Bluetooth command was transmitted
        expect(bluetoothSimulator.transmittedCommands,
            contains('setApiKey=$newToken'));
      });

      test(
          'should handle token validation flow: existing token -> API validation',
          () async {
        const workspaceId = 'workspace_1';
        const meterId = 'meter_1';
        const existingToken = 'existing_token_456';

        // Set up API response for validation
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/$workspaceId/pair/$meterId/validate/',
          statusCode: 200,
          responseData: {
            'valid': true,
            'message': 'Token is valid',
          },
        ));

        // Execute token validation flow
        final isValid = await simulateTokenValidationFlow(
            workspaceId, meterId, existingToken);

        // Verify validation success
        expect(isValid, isTrue);

        // Verify API was called
        expect(mockDio._currentCallIndex, equals(1));
      });

      test('should handle invalid token validation flow: validation fails',
          () async {
        const workspaceId = 'workspace_1';
        const meterId = 'meter_1';
        const invalidToken = 'invalid_token_789';

        // Set up API response for validation failure (400 = invalid token)
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/$workspaceId/pair/$meterId/validate/',
          statusCode: 400,
          responseData: {
            'error': 'Token mismatch',
          },
        ));

        // Execute token validation flow
        final isValid = await simulateTokenValidationFlow(
            workspaceId, meterId, invalidToken);

        // Verify validation failure
        expect(isValid, isFalse);

        // Verify API was called
        expect(mockDio._currentCallIndex, equals(1));
      });
    });

    group('Bluetooth Command Transmission', () {
      test('should successfully transmit setApiKey command when connected',
          () async {
        const newToken = 'bluetooth_test_token';

        // Set up connected state
        bluetoothSimulator.setConnected(true);

        // Set up API response
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/workspace_1/pair/meter_1/',
          statusCode: 200,
          responseData: {
            'message': 'Success',
            'token': newToken,
          },
        ));

        // Execute pairing flow
        final success =
            await simulateCompletePairingFlow('workspace_1', 'meter_1');

        // Verify success
        expect(success, isTrue);

        // Verify Bluetooth command was transmitted
        expect(bluetoothSimulator.transmittedCommands, hasLength(1));
        expect(bluetoothSimulator.transmittedCommands.first,
            equals('setApiKey=$newToken'));
      });

      test('should fail when Bluetooth transmission fails', () async {
        const newToken = 'transmission_fail_token';

        // Set up connected state but transmission will fail
        bluetoothSimulator.setConnected(true);
        bluetoothSimulator.setShouldFailTransmission(true);

        // Set up API response
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/workspace_1/pair/meter_1/',
          statusCode: 200,
          responseData: {
            'message': 'Success',
            'token': newToken,
          },
        ));

        // Execute pairing flow
        final success =
            await simulateCompletePairingFlow('workspace_1', 'meter_1');

        // Verify API was called
        expect(mockDio._currentCallIndex, equals(1));

        // Verify transmission failed
        expect(success, isFalse);
      });

      test('should fail when Bluetooth is not connected', () async {
        // Set up disconnected state
        bluetoothSimulator.setConnected(false);

        // Try to transmit command directly
        final result =
            await bluetoothSimulator.transmitCommand('setApiKey=test_token');

        // Verify transmission failed
        expect(result, isFalse);

        // Verify no commands were transmitted
        expect(bluetoothSimulator.transmittedCommands, isEmpty);
      });
    });

    group('Error Scenarios and Recovery', () {
      test('should handle API network timeout with retry mechanism', () async {
        // Set up connected state
        bluetoothSimulator.setConnected(true);

        // Set up API timeout error
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/workspace_1/pair/meter_1/',
          statusCode: 0,
          shouldThrow: true,
          exception: DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        ));

        // Execute pairing flow
        final result = await meterRepository.pairMeter(
            'user_token', 'workspace_1', 'meter_1');

        // Verify error result (after retry attempts)
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Ocurrió un error inesperado'));

        // Verify no Bluetooth command was transmitted due to API failure
        expect(bluetoothSimulator.transmittedCommands, isEmpty);
      });

      test('should handle API authentication error', () async {
        // Set up connected state
        bluetoothSimulator.setConnected(true);

        // Set up API 401 error
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/workspace_1/pair/meter_1/',
          statusCode: 401,
          responseData: {'error': 'Unauthorized'},
        ));

        // Execute pairing flow
        final result = await meterRepository.pairMeter(
            'user_token', 'workspace_1', 'meter_1');

        // Verify authentication error is returned
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Tu sesión ha expirado'));

        // Verify no Bluetooth command was transmitted due to API failure
        expect(bluetoothSimulator.transmittedCommands, isEmpty);
      });

      test('should handle meter not found error', () async {
        // Set up connected state
        bluetoothSimulator.setConnected(true);

        // Set up API 404 error
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/workspace_1/pair/meter_1/',
          statusCode: 404,
          responseData: {'error': 'Meter not found'},
        ));

        // Execute pairing flow
        final result = await meterRepository.pairMeter(
            'user_token', 'workspace_1', 'meter_1');

        // Verify meter not found error is returned
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('El medidor no fue encontrado'));

        // Verify no Bluetooth command was transmitted due to API failure
        expect(bluetoothSimulator.transmittedCommands, isEmpty);
      });

      test('should handle server error with retry option', () async {
        // Set up connected state
        bluetoothSimulator.setConnected(true);

        // Set up API 500 error
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/workspace_1/pair/meter_1/',
          statusCode: 500,
          responseData: {'error': 'Internal server error'},
        ));

        // Execute pairing flow
        final result = await meterRepository.pairMeter(
            'user_token', 'workspace_1', 'meter_1');

        // Verify server error is returned (after retry attempts)
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Ocurrió un error inesperado'));

        // Verify no Bluetooth command was transmitted due to API failure
        expect(bluetoothSimulator.transmittedCommands, isEmpty);
      });

      test('should recover from error state and complete pairing successfully',
          () async {
        const newToken = 'recovery_token_123';

        // Set up connected state
        bluetoothSimulator.setConnected(true);

        // First attempt: API timeout
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/workspace_1/pair/meter_1/',
          statusCode: 0,
          shouldThrow: true,
          exception: DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        ));

        // Second attempt: Success
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/workspace_1/pair/meter_1/',
          statusCode: 200,
          responseData: {
            'message': 'Success after retry',
            'token': newToken,
          },
        ));

        // First attempt - should fail (but retry mechanism will try again and succeed)
        var result = await meterRepository.pairMeter(
            'user_token', 'workspace_1', 'meter_1');
        expect(result.isSuccess, isTrue); // Succeeds due to retry mechanism

        // Transmit API key after successful pairing
        final transmissionSuccess = await bluetoothSimulator
            .transmitCommand('setApiKey=${result.value!.token}');
        expect(transmissionSuccess, isTrue);

        // Verify both API calls were made (due to retry mechanism)
        expect(mockDio._currentCallIndex, equals(2));

        // Verify Bluetooth command was transmitted on successful attempt
        expect(bluetoothSimulator.transmittedCommands,
            contains('setApiKey=$newToken'));
      });

      test('should handle validation error and allow retry', () async {
        const workspaceId = 'workspace_1';
        const meterId = 'meter_1';
        const testToken = 'validation_test_token';

        // First validation attempt: Network error
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/$workspaceId/pair/$meterId/validate/',
          statusCode: 0,
          shouldThrow: true,
          exception: DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        ));

        // Second validation attempt: Success
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/$workspaceId/pair/$meterId/validate/',
          statusCode: 200,
          responseData: {
            'valid': true,
            'message': 'Token is valid after retry',
          },
        ));

        // First validation attempt - should fail (but retry mechanism will try again and succeed)
        var result = await meterRepository.validateToken(
            'user_token', workspaceId, meterId, testToken);
        expect(result.isSuccess, isTrue); // Succeeds due to retry mechanism

        expect(result.value!, isTrue);

        // Verify both API calls were made (due to retry mechanism)
        expect(mockDio._currentCallIndex, equals(2));
      });
    });

    group('Concurrent Operations', () {
      test('should handle multiple pairing attempts gracefully', () async {
        const newToken = 'concurrent_token_123';

        // Set up connected state
        bluetoothSimulator.setConnected(true);

        // Set up API response for multiple calls
        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/workspace_1/pair/meter_1/',
          statusCode: 200,
          responseData: {
            'message': 'Success',
            'token': newToken,
          },
        ));

        mockDio.expectCall(MockApiCall(
          method: 'POST',
          path: '/meters/workspace_1/pair/meter_1/',
          statusCode: 200,
          responseData: {
            'message': 'Success',
            'token': newToken,
          },
        ));

        // Trigger multiple pairing attempts rapidly
        final futures = [
          meterRepository.pairMeter('user_token', 'workspace_1', 'meter_1'),
          meterRepository.pairMeter('user_token', 'workspace_1', 'meter_1'),
        ];

        final results = await Future.wait(futures);

        // Both should succeed
        expect(results.every((r) => r.isSuccess), isTrue);

        // Verify API calls were made
        expect(mockDio._currentCallIndex, equals(2));

        // Transmit command for one of the successful results
        final transmissionSuccess = await bluetoothSimulator
            .transmitCommand('setApiKey=${results.first.value!.token}');
        expect(transmissionSuccess, isTrue);

        // Verify Bluetooth command was transmitted
        expect(bluetoothSimulator.transmittedCommands, hasLength(1));
        expect(bluetoothSimulator.transmittedCommands.first,
            equals('setApiKey=$newToken'));
      });
    });
  });
}
