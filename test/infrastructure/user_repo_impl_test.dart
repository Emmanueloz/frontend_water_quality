import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/user_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/enums/roles.dart';
import '../utils/mock_dio.dart';

void main() {
  group('UserRepositoryImpl Tests', () {
    late MockDio mockDio;
    late UserRepoImpl repository;

    // Test data
    final testUser = User(
      uid: 'user_1',
      email: 'test@example.com',
      username: 'testuser',
      phone: '1234567890',
      rol: AppRoles.admin,
    );

    setUp(() {
      mockDio = MockDio();
      repository = UserRepoImpl(mockDio);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('getUser', () {
      test('should return success when API returns 200 with user data',
          () async {
        // Arrange
        final responseData = {
          'user': {
            'uid': 'user_1',
            'email': 'test@example.com',
            'username': 'testuser',
            'phone': '1234567890',
            'rol': 'admin',
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getUser('test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<User>());
        expect(result.value!.uid, equals('user_1'));
        expect(result.value!.email, equals('test@example.com'));
        expect(result.value!.username, equals('testuser'));
        expect(result.value!.phone, equals('1234567890'));
        expect(result.value!.rol, equals(AppRoles.admin));
      });

      test('should return failure when API returns non-200 status code',
          () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'User not found'},
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getUser('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 404'));
      });

      test('should return failure when API returns 401 unauthorized', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Unauthorized'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getUser('invalid_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 401'));
      });

      test('should return failure when API returns 403 forbidden', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Forbidden'},
          statusCode: 403,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getUser('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 403'));
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
        final result = await repository.getUser('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 500'));
      });

      test('should handle DioException with connection timeout', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getUser('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });

      test('should handle DioException with connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getUser('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });

    group('update', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'message': 'User updated successfully',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('test_token', testUser);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<BaseResponse>());
        expect(result.value!.message, equals('User updated successfully'));
      });

      test('should return success when API returns 201', () async {
        // Arrange
        final responseData = {
          'message': 'User updated',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('test_token', testUser);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<BaseResponse>());
        expect(result.value!.message, equals('User updated'));
      });

      test('should return failure when API returns 400 bad request', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Invalid data'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('test_token', testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 400'));
      });

      test('should return failure when API returns 401 unauthorized', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Unauthorized'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('invalid_token', testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 401'));
      });

      test('should return failure when API returns 403 forbidden', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Forbidden'},
          statusCode: 403,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('test_token', testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 403'));
      });

      test('should return failure when API returns 404 not found', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'User not found'},
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('test_token', testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 404'));
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
        final result = await repository.update('test_token', testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 500'));
      });

      test('should handle DioException with connection timeout', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('test_token', testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });

      test('should handle DioException with connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('test_token', testUser);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });

    group('updatePassword', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'message': 'Password updated successfully',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.updatePassword('test_token', 'newPassword123');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<BaseResponse>());
        expect(result.value!.message, equals('Password updated successfully'));
      });

      test('should return success when API returns 201', () async {
        // Arrange
        final responseData = {
          'message': 'Password changed',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.updatePassword('test_token', 'newPassword123');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<BaseResponse>());
        expect(result.value!.message, equals('Password changed'));
      });

      test('should return failure when API returns 400 bad request', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Invalid password'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.updatePassword('test_token', 'weak');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 400'));
      });

      test('should return failure when API returns 401 unauthorized', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Unauthorized'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.updatePassword('invalid_token', 'newPassword123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 401'));
      });

      test('should return failure when API returns 403 forbidden', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Forbidden'},
          statusCode: 403,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.updatePassword('test_token', 'newPassword123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 403'));
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
            await repository.updatePassword('test_token', 'newPassword123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 404'));
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
        final result =
            await repository.updatePassword('test_token', 'newPassword123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 500'));
      });

      test('should handle DioException with connection timeout', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.updatePassword('test_token', 'newPassword123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });

      test('should handle DioException with connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.updatePassword('test_token', 'newPassword123');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });
  });
}
