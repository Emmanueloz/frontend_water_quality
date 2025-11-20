import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/guest_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import '../utils/mock_dio.dart';

void main() {
  group('GuestRepositoryImpl Tests', () {
    late MockDio mockDio;
    late GuestRepositoryImpl repository;

    setUp(() {
      mockDio = MockDio();
      repository = GuestRepositoryImpl(mockDio);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('listGuests', () {
      test('should return success when API returns 200 with direct list',
          () async {
        // Arrange
        final responseData = [
          {
            'id': 'guest_1',
            'name': 'John Doe',
            'email': 'john.doe@example.com',
            'role': 'viewer',
          },
          {
            'id': 'guest_2',
            'name': 'Jane Smith',
            'email': 'jane.smith@example.com',
            'role': 'editor',
          }
        ];
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listGuests('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Guest>>());
        expect(result.value!.length, equals(2));
        expect(result.value![0].id, equals('guest_1'));
        expect(result.value![0].name, equals('John Doe'));
        expect(result.value![0].email, equals('john.doe@example.com'));
        expect(result.value![0].role, equals('viewer'));
      });

      test('should return success when API returns 200 with data wrapper',
          () async {
        // Arrange
        final responseData = {
          'data': [
            {
              'id': 'guest_1',
              'name': 'John Doe',
              'email': 'john.doe@example.com',
              'role': 'viewer',
            }
          ]
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listGuests('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Guest>>());
        expect(result.value!.length, equals(1));
        expect(result.value![0].id, equals('guest_1'));
      });

      test('should return success when API returns 200 with guests wrapper',
          () async {
        // Arrange
        final responseData = {
          'guests': [
            {
              'id': 'guest_1',
              'name': 'John Doe',
              'email': 'john.doe@example.com',
              'role': 'viewer',
            }
          ]
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listGuests('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Guest>>());
        expect(result.value!.length, equals(1));
      });

      test('should return success when API returns 200 with empty list',
          () async {
        // Arrange
        final responseData = <dynamic>[];
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listGuests('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Guest>>());
        expect(result.value!.length, equals(0));
      });

      test('should return failure when API returns 401', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.listGuests('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 403', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.listGuests('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 404', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.listGuests('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 500', () async {
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
        final result = await repository.listGuests('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listGuests('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should handle connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listGuests('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });
    });

    group('inviteGuest', () {
      test('should return success when API returns 201 with guest wrapper',
          () async {
        // Arrange
        final responseData = {
          'guest': {
            'id': 'guest_1',
            'name': 'John Doe',
            'email': 'john.doe@example.com',
            'role': 'viewer',
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.inviteGuest(
            'test_token', 'workspace_1', 'john.doe@example.com', 'viewer');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<Guest>());
        expect(result.value!.id, equals('guest_1'));
        expect(result.value!.name, equals('John Doe'));
        expect(result.value!.email, equals('john.doe@example.com'));
        expect(result.value!.role, equals('viewer'));
      });

      test('should return success when API returns 200 with direct object',
          () async {
        // Arrange
        final responseData = {
          'id': 'guest_1',
          'name': 'John Doe',
          'email': 'john.doe@example.com',
          'role': 'viewer',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.inviteGuest(
            'test_token', 'workspace_1', 'john.doe@example.com', 'viewer');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<Guest>());
        expect(result.value!.id, equals('guest_1'));
      });

      test('should return failure when API returns 400', () async {
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
        final result = await repository.inviteGuest(
            'test_token', 'workspace_1', 'john.doe@example.com', 'viewer');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 401', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.inviteGuest(
            'test_token', 'workspace_1', 'john.doe@example.com', 'viewer');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 403', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.inviteGuest(
            'test_token', 'workspace_1', 'john.doe@example.com', 'viewer');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 500', () async {
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
        final result = await repository.inviteGuest(
            'test_token', 'workspace_1', 'john.doe@example.com', 'viewer');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.inviteGuest(
            'test_token', 'workspace_1', 'john.doe@example.com', 'viewer');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });
    });

    group('updateGuestRole', () {
      test('should return success when API returns 200 with guest wrapper',
          () async {
        // Arrange
        final responseData = {
          'guest': {
            'id': 'guest_1',
            'name': 'John Doe',
            'email': 'john.doe@example.com',
            'role': 'editor',
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.updateGuestRole(
            'test_token', 'workspace_1', 'guest_1', 'editor');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<Guest>());
        expect(result.value!.id, equals('guest_1'));
        expect(result.value!.role, equals('editor'));
      });

      test('should return success when API returns 200 with direct object',
          () async {
        // Arrange
        final responseData = {
          'id': 'guest_1',
          'name': 'John Doe',
          'email': 'john.doe@example.com',
          'role': 'editor',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.updateGuestRole(
            'test_token', 'workspace_1', 'guest_1', 'editor');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<Guest>());
        expect(result.value!.role, equals('editor'));
      });

      test('should return failure when API returns 400', () async {
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
        final result = await repository.updateGuestRole(
            'test_token', 'workspace_1', 'guest_1', 'editor');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 401', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.updateGuestRole(
            'test_token', 'workspace_1', 'guest_1', 'editor');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 403', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.updateGuestRole(
            'test_token', 'workspace_1', 'guest_1', 'editor');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 404', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.updateGuestRole(
            'test_token', 'workspace_1', 'guest_1', 'editor');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 500', () async {
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
        final result = await repository.updateGuestRole(
            'test_token', 'workspace_1', 'guest_1', 'editor');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.updateGuestRole(
            'test_token', 'workspace_1', 'guest_1', 'editor');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });
    });

    group('deleteGuest', () {
      test('should return success when DELETE returns 200', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Guest deleted'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.deleteGuest(
            'test_token', 'workspace_1', 'guest_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isTrue);
      });

      test('should return success when DELETE returns 204', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: null,
          statusCode: 204,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.deleteGuest(
            'test_token', 'workspace_1', 'guest_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isTrue);
      });

      test('should return failure when API returns 400', () async {
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
        final result = await repository.deleteGuest(
            'test_token', 'workspace_1', 'guest_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 401', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.deleteGuest(
            'test_token', 'workspace_1', 'guest_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 403', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.deleteGuest(
            'test_token', 'workspace_1', 'guest_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 404', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.deleteGuest(
            'test_token', 'workspace_1', 'guest_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 500', () async {
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
        final result = await repository.deleteGuest(
            'test_token', 'workspace_1', 'guest_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.deleteGuest(
            'test_token', 'workspace_1', 'guest_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should handle connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.deleteGuest(
            'test_token', 'workspace_1', 'guest_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });
    });
  });
}
