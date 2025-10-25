import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/meter_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/pairing_response.dart';

class MockDio implements Dio {
  Response<dynamic>? mockResponse;
  DioException? mockError;
  int callCount = 0;

  void reset() {
    mockResponse = null;
    mockError = null;
    callCount = 0;
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
    callCount++;
    if (mockError != null) {
      throw mockError!;
    }
    return mockResponse as Response<T>;
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

void main() {
  group('MeterRepoImpl Pairing Tests', () {
    late MockDio mockDio;
    late MeterRepoImpl repository;

    setUp(() {
      mockDio = MockDio();
      repository = MeterRepoImpl(mockDio);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('validateToken', () {
      test('should return success when API returns valid token', () async {
        // Arrange
        final responseData = {
          'valid': true,
          'message': 'Token is valid',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.validateToken(
          'user_token',
          'workspace_1',
          'meter_1',
          'device_token',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isTrue);
      });

      test('should return success when API returns invalid token', () async {
        // Arrange
        final responseData = {
          'valid': false,
          'message': 'Token mismatch',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.validateToken(
          'user_token',
          'workspace_1',
          'meter_1',
          'device_token',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!, isFalse);
      });

      test('should return failure when API returns 401', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'error': 'Unauthorized'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.validateToken(
          'user_token',
          'workspace_1',
          'meter_1',
          'device_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Tu sesión ha expirado'));
      });

      test('should return failure when API returns 404', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'error': 'Not found'},
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.validateToken(
          'user_token',
          'workspace_1',
          'meter_1',
          'device_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('El medidor no fue encontrado'));
      });

      test('should retry on connection timeout', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.validateToken(
          'user_token',
          'workspace_1',
          'meter_1',
          'device_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(mockDio.callCount, greaterThan(1)); // Should have retried
        expect(result.message, contains('La conexión tardó demasiado tiempo'));
      });

      test('should retry on server error (500)', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'error': 'Internal server error'},
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.validateToken(
          'user_token',
          'workspace_1',
          'meter_1',
          'device_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(mockDio.callCount, greaterThan(1)); // Should have retried
        expect(result.message, contains('Error del servidor'));
      });

      test('should not retry on client error (400)', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'error': 'Bad request'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.validateToken(
          'user_token',
          'workspace_1',
          'meter_1',
          'device_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(mockDio.callCount, equals(1)); // Should not retry
        expect(result.message, contains('Datos inválidos'));
      });
    });

    group('pairMeter', () {
      test('should return success when API returns new token', () async {
        // Arrange
        final responseData = {
          'message': 'Meter paired successfully',
          'token': 'new_device_token_123',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.pairMeter(
          'user_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<PairingResponse>());
        expect(result.value!.message, equals('Meter paired successfully'));
        expect(result.value!.token, equals('new_device_token_123'));
      });

      test('should return success when API returns 201', () async {
        // Arrange
        final responseData = {
          'message': 'Meter paired successfully',
          'token': 'new_device_token_123',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.pairMeter(
          'user_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<PairingResponse>());
        expect(result.value!.token, equals('new_device_token_123'));
      });

      test('should return failure when API returns 401', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'error': 'Unauthorized'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.pairMeter(
          'user_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Tu sesión ha expirado'));
      });

      test('should return failure when API returns 404', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'error': 'Meter not found'},
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.pairMeter(
          'user_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('El medidor no fue encontrado'));
      });

      test('should retry on connection timeout', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.pairMeter(
          'user_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(mockDio.callCount, greaterThan(1)); // Should have retried
        expect(result.message, contains('La conexión tardó demasiado tiempo'));
      });

      test('should retry on connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.pairMeter(
          'user_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(mockDio.callCount, greaterThan(1)); // Should have retried
        expect(result.message, contains('No hay conexión a internet'));
      });

      test('should handle unknown exception', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(path: ''),
          error: 'Network connection failed',
        );

        // Act
        final result = await repository.pairMeter(
          'user_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(mockDio.callCount, equals(1)); // Unknown errors are not retried
        expect(result.message, contains('No hay conexión a internet'));
      });
    });
  });
}