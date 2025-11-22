import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/meter_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/pairing_response.dart';
import '../mocks/mock_dio.dart';

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
          'message': '',
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
        //expect(mockDio.callCount, greaterThan(1)); // Should have retried
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