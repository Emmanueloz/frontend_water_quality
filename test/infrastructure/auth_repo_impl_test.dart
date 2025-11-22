import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/auth_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/core/interface/response/login_response.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/response/verify_code_response.dart';
import 'package:frontend_water_quality/core/enums/roles.dart';
import '../mocks/mock_dio.dart';

void main() {
  group('AuthRepositoryImpl Tests', () {
    late MockDio mockDio;
    late AuthRepoImpl repository;

    // Test data
    final testUser = User(
      uid: 'user_1',
      email: 'test@example.com',
      username: 'testuser',
      phone: '1234567890',
      password: 'password123',
      rol: AppRoles.admin,
    );

    final testLoginUser = User(
      email: 'test@example.com',
      password: 'password123',
    );

    setUp(() {
      mockDio = MockDio();
      repository = AuthRepoImpl(mockDio);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('login', () {
      test('should return success when API returns 200 with valid credentials',
          () async {
        // Arrange
        final responseData = {
          'user': {
            'uid': 'user_1',
            'email': 'test@example.com',
            'username': 'testuser',
            'rol': 'admin',
          },
          'token': 'test_token_123',
          'message': 'Login successful',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.login(testLoginUser);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<LoginResponse>());
        expect(result.value!.token, equals('test_token_123'));
        expect(result.value!.user, isNotNull);
        expect(result.value!.user!.email, equals('test@example.com'));
      });

      test('should return failure when API returns non-200 status code',
          () async {
        // Arrange
        final responseData = {
          'detail': 'Invalid credentials',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.login(testLoginUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('Invalid credentials'));
      });

      test('should return failure when API returns 401 unauthorized', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            data: {'detail': 'Unauthorized'},
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.login(testLoginUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(
            result.message, contains('Fallo al iniciar sesión'));
      });

      test('should return failure when API returns 400 bad request', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.login(testLoginUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(
            result.message, contains('Fallo al iniciar sesión'));
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.login(testLoginUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(
            result.message, contains('Fallo al iniciar sesión'));
      });

      test('should handle connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.login(testLoginUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(
            result.message, contains('Fallo al iniciar sesión'));
      });
    });

    group('register', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'message': 'User registered successfully',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.register(testUser);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<BaseResponse>());
        expect(result.value!.message, equals('User registered successfully'));
      });

      test('should return failure when API returns 409 conflict', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'User already exists'},
          statusCode: 409,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.register(testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('El usuario ya existe'));
      });

      test('should return failure when API returns 400 bad request', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Invalid data'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.register(testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 400'));
      });

      test('should return failure when API returns 500 server error',
          () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Internal server error'},
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.register(testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 500'));
      });

      test('should handle DioException', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.register(testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.register(testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });

    group('requestPasswordReset', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'message': 'Password reset email sent',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.requestPasswordReset('test@example.com');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<BaseResponse>());
        expect(result.value!.message, equals('Password reset email sent'));
      });

      test('should return failure when API returns 400 bad request', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Invalid email'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.requestPasswordReset('invalid@example.com');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 400'));
      });

      test('should return failure when API returns 404 not found', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'User not found'},
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.requestPasswordReset('notfound@example.com');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 404'));
      });

      test('should return failure when API returns 500 server error',
          () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Server error'},
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.requestPasswordReset('test@example.com');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 500'));
      });

      test('should handle DioException with connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.requestPasswordReset('test@example.com');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('Error de conexión'));
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.requestPasswordReset('test@example.com');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('Error de conexión'));
      });
    });

    group('verifyResetCode', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'message': 'Code verified',
          'token': 'reset_token_123',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.verifyResetCode('test@example.com', '123456');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<VerifyCodeResponse>());
        expect(result.value!.token, equals('reset_token_123'));
        expect(result.value!.message, equals('Code verified'));
      });

      test('should return failure when API returns 400 bad request', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Invalid code'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.verifyResetCode('test@example.com', 'invalid');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 400'));
      });

      test('should return failure when API returns 401 unauthorized', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Code expired'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.verifyResetCode('test@example.com', '123456');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 401'));
      });

      test('should return failure when API returns 500 server error',
          () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Server error'},
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.verifyResetCode('test@example.com', '123456');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 500'));
      });

      test('should handle DioException', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result =
            await repository.verifyResetCode('test@example.com', '123456');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.verifyResetCode('test@example.com', '123456');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });

    group('resetPassword', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'message': 'Password reset successfully',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.resetPassword('reset_token_123', 'newPassword123');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<BaseResponse>());
        expect(result.value!.message, equals('Password reset successfully'));
      });

      test('should return failure when API returns 401 with invalid token',
          () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Invalid token'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.resetPassword('invalid_token', 'newPassword123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('Token inválido'));
      });

      test('should return failure when API returns 400 bad request', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Invalid password'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.resetPassword('reset_token_123', 'weak');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 400'));
      });

      test('should return failure when API returns 500 server error',
          () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Server error'},
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.resetPassword('reset_token_123', 'newPassword123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 500'));
      });

      test('should handle DioException', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result =
            await repository.resetPassword('reset_token_123', 'newPassword123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.resetPassword('reset_token_123', 'newPassword123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });

    group('isTokenExpired', () {
      test('should return false when API returns 200 (token is valid)',
          () async {
        // Arrange
        final responseData = {
          'uid': 'user_1',
          'email': 'test@example.com',
          'username': 'testuser',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.isTokenExpired('valid_token_123');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isFalse); // false means not expired
      });

      test('should return failure when API returns 401 unauthorized', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Unauthorized'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.isTokenExpired('expired_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('status 401'));
      });

      test('should return failure when API returns 403 forbidden', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Forbidden'},
          statusCode: 403,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.isTokenExpired('invalid_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('status 403'));
      });

      test('should return failure when API returns 500 server error',
          () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Server error'},
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.isTokenExpired('valid_token_123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('status 500'));
      });

      test('should handle DioException with connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.isTokenExpired('valid_token_123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.isTokenExpired('valid_token_123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });
  });
}
