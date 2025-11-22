import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/notification_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';
import 'package:frontend_water_quality/core/enums/notification_status.dart';
import '../mocks/mock_dio.dart';

void main() {
  group('NotificationRepositoryImpl Tests', () {
    late MockDio mockDio;
    late NotificationRepoImpl repository;

    setUp(() {
      mockDio = MockDio();
      repository = NotificationRepoImpl(mockDio);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('listNotifications', () {
      test('should return success when API returns 200 with notifications array',
          () async {
        // Arrange
        final responseData = {
          'notifications': [
            {
              'id': 'notification_1',
              'read': false,
              'title': 'High Temperature Alert',
              'body': 'Temperature exceeded threshold at meter_1',
              'user_ids': ['user_1', 'user_2'],
              'datetime': '2024-01-15T10:30:00Z',
              'status': 'pending',
              'aproved_by': null,
              'record_parameters': [
                {'parameter': 'temperature', 'value': 35.5},
                {'parameter': 'ph', 'value': 7.2},
              ],
            }
          ]
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listNotifications(
          'test_token',
          false,
          NotificationStatus.pending,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<NotificationModel>>());
        expect(result.value!.length, equals(1));
        expect(result.value![0].id, equals('notification_1'));
        expect(result.value![0].title, equals('High Temperature Alert'));
        expect(result.value![0].read, isFalse);
        expect(result.value![0].status, equals('pending'));
      });

      test('should return success when API returns 200 with empty notifications array',
          () async {
        // Arrange
        final responseData = {'notifications': []};
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listNotifications(
          'test_token',
          true,
          NotificationStatus.accepted,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<NotificationModel>>());
        expect(result.value!.length, equals(0));
      });

      test('should return success when notifications field is null', () async {
        // Arrange
        final responseData = {'notifications': null};
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listNotifications(
          'test_token',
          false,
          NotificationStatus.pending,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<NotificationModel>>());
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
        final result = await repository.listNotifications(
          'test_token',
          false,
          NotificationStatus.pending,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
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
        final result = await repository.listNotifications(
          'test_token',
          false,
          NotificationStatus.pending,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
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
        final result = await repository.listNotifications(
          'test_token',
          false,
          NotificationStatus.pending,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
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
        final result = await repository.listNotifications(
          'test_token',
          false,
          NotificationStatus.pending,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listNotifications(
          'test_token',
          false,
          NotificationStatus.pending,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listNotifications(
          'test_token',
          false,
          NotificationStatus.pending,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });

    group('getNotificationDetails', () {
      test('should return success when API returns 200 with notification object',
          () async {
        // Arrange
        final responseData = {
          'notification': {
            'id': 'notification_1',
            'read': false,
            'title': 'High Temperature Alert',
            'body': 'Temperature exceeded threshold at meter_1',
            'user_ids': ['user_1'],
            'datetime': '2024-01-15T10:30:00Z',
            'status': 'pending',
            'aproved_by': null,
            'record_parameters': [
              {'parameter': 'temperature', 'value': 35.5},
            ],
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getNotificationDetails(
          'test_token',
          'notification_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<NotificationModel>());
        expect(result.value!.id, equals('notification_1'));
        expect(result.value!.title, equals('High Temperature Alert'));
        expect(result.value!.read, isFalse);
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
        final result = await repository.getNotificationDetails(
          'test_token',
          'notification_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
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
        final result = await repository.getNotificationDetails(
          'test_token',
          'notification_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
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
        final result = await repository.getNotificationDetails(
          'test_token',
          'notification_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
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
        final result = await repository.getNotificationDetails(
          'test_token',
          'notification_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getNotificationDetails(
          'test_token',
          'notification_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle receive timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getNotificationDetails(
          'test_token',
          'notification_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });

    group('changeStatus (markAsRead)', () {
      test('should return success when API returns 200', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Notification status updated'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.changeStatus(
          'test_token',
          'notification_1',
          NotificationStatus.accepted,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Notificacion actualizada'));
      });

      test('should return success when changing status to pending', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Status updated'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.changeStatus(
          'test_token',
          'notification_1',
          NotificationStatus.pending,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Notificacion actualizada'));
      });

      test('should return success when changing status to rejected', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Status updated'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.changeStatus(
          'test_token',
          'notification_1',
          NotificationStatus.rejected,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Notificacion actualizada'));
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
        final result = await repository.changeStatus(
          'test_token',
          'notification_1',
          NotificationStatus.accepted,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
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
        final result = await repository.changeStatus(
          'test_token',
          'notification_1',
          NotificationStatus.accepted,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
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
        final result = await repository.changeStatus(
          'test_token',
          'notification_1',
          NotificationStatus.accepted,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
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
        final result = await repository.changeStatus(
          'test_token',
          'notification_1',
          NotificationStatus.accepted,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
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
        final result = await repository.changeStatus(
          'test_token',
          'notification_1',
          NotificationStatus.accepted,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.changeStatus(
          'test_token',
          'notification_1',
          NotificationStatus.accepted,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.changeStatus(
          'test_token',
          'notification_1',
          NotificationStatus.accepted,
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });
  });
}
