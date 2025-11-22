import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/alert_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/core/enums/alert_type.dart';
import '../mocks/mock_dio.dart';

void main() {
  group('AlertRepositoryImpl Tests', () {
    late MockDio mockDio;
    late AlertRepositoryImpl repository;

    // Test data
    final testAlert = Alert(
      id: 'alert_1',
      title: 'High Temperature Alert',
      type: AlertType.moderate,
      workspaceId: 'workspace_1',
      meterId: 'meter_1',
      parameters: Parameter(
        ph: RangeValue(min: 6.5, max: 8.5),
        temperature: RangeValue(min: 0.0, max: 30.0),
        tds: RangeValue(min: 0.0, max: 500.0),
        conductivity: RangeValue(min: 0.0, max: 1000.0),
        turbidity: RangeValue(min: 0.0, max: 5.0),
      ),
      sendToUsers: ['user_1', 'user_2'],
    );

    setUp(() {
      mockDio = MockDio();
      repository = AlertRepositoryImpl(mockDio);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('listAlerts', () {
      test('should return success when API returns 200 with alerts array',
          () async {
        // Arrange
        final responseData = {
          'alerts': [
            {
              'id': 'alert_1',
              'title': 'High Temperature Alert',
              'type': 'moderate',
              'workspace_id': 'workspace_1',
              'meter_id': 'meter_1',
              'parameters': {
                'ph': {'min': 6.5, 'max': 8.5},
                'temperature': {'min': 0.0, 'max': 30.0},
                'tds': {'min': 0.0, 'max': 500.0},
                'conductivity': {'min': 0.0, 'max': 1000.0},
                'turbidity': {'min': 0.0, 'max': 5.0},
              },
              'guests': ['user_1', 'user_2'],
            }
          ]
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listAlerts('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Alert>>());
        expect(result.value!.length, equals(1));
        expect(result.value![0].id, equals('alert_1'));
        expect(result.value![0].title, equals('High Temperature Alert'));
      });

      test('should return success when API returns 200 with empty alerts array',
          () async {
        // Arrange
        final responseData = {'alerts': []};
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listAlerts('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Alert>>());
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
        final result = await repository.listAlerts('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('No autorizado'));
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
        final result = await repository.listAlerts('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('No tiene permisos'));
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.listAlerts('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Tiempo de conexión agotado'));
      });
    });

    group('getAlertDetails', () {
      test('should return success when API returns 200 with alert object',
          () async {
        // Arrange
        final responseData = {
          'alert': {
            'id': 'alert_1',
            'title': 'High Temperature Alert',
            'type': 'moderate',
            'workspace_id': 'workspace_1',
            'meter_id': 'meter_1',
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.getAlertDetails('test_token', 'alert_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<Alert>());
        expect(result.value!.id, equals('alert_1'));
        expect(result.value!.title, equals('High Temperature Alert'));
      });

      test('should return success when API returns 200 with direct object',
          () async {
        // Arrange
        final responseData = {
          'id': 'alert_1',
          'title': 'High Temperature Alert',
          'type': 'moderate',
          'workspace_id': 'workspace_1',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.getAlertDetails('test_token', 'alert_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<Alert>());
        expect(result.value!.id, equals('alert_1'));
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
        final result =
            await repository.getAlertDetails('test_token', 'alert_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Alerta no encontrada'));
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
        final result =
            await repository.getAlertDetails('test_token', 'alert_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('No autorizado'));
      });
    });

    group('createAlert', () {
      test('should return success when API returns 201', () async {
        // Arrange
        final responseData = {
          'alert': {
            'id': 'alert_1',
            'title': 'High Temperature Alert',
            'type': 'moderate',
            'workspace_id': 'workspace_1',
            'meter_id': 'meter_1',
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createAlert('test_token', testAlert);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<Alert>());
        expect(result.value!.id, equals('alert_1'));
      });

      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'id': 'alert_1',
          'title': 'High Temperature Alert',
          'type': 'moderate',
          'workspace_id': 'workspace_1',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createAlert('test_token', testAlert);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<Alert>());
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
        final result = await repository.createAlert('test_token', testAlert);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error de conexión'));
      });

      test('should return failure when API returns 422', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 422,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result = await repository.createAlert('test_token', testAlert);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Datos inválidos'));
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
        final result = await repository.createAlert('test_token', testAlert);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('No tiene permisos'));
      });
    });

    group('updateAlert', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'alert': {
            'id': 'alert_1',
            'title': 'Updated Alert',
            'type': 'moderate',
            'workspace_id': 'workspace_1',
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result =
            await repository.updateAlert('test_token', 'alert_1', testAlert);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<Alert>());
        expect(result.value!.id, equals('alert_1'));
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
        final result =
            await repository.updateAlert('test_token', 'alert_1', testAlert);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Alerta no encontrada'));
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
        final result =
            await repository.updateAlert('test_token', 'alert_1', testAlert);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('No autorizado'));
      });

      test('should return failure when API returns 422', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 422,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // Act
        final result =
            await repository.updateAlert('test_token', 'alert_1', testAlert);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Datos inválidos'));
      });
    });

    group('deleteAlert', () {
      test('should return success when API returns 200', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Alert deleted'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.deleteAlert('test_token', 'alert_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isTrue);
      });

      test('should return success when API returns 204', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: null,
          statusCode: 204,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.deleteAlert('test_token', 'alert_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isTrue);
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
        final result = await repository.deleteAlert('test_token', 'alert_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Alerta no encontrada'));
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
        final result = await repository.deleteAlert('test_token', 'alert_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('No tiene permisos'));
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.deleteAlert('test_token', 'alert_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Tiempo de conexión agotado'));
      });
    });

    group('getAlertNotifications', () {
      test('should return failure as method is not implemented', () async {
        // Act
        final result = await repository.getAlertNotifications('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error al cargar las notificaciones'));
      });
    });

    group('markNotificationAsRead', () {
      test('should return success when API returns 200', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Notification marked as read'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.markNotificationAsRead(
            'test_token', 'notification_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isTrue);
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
        final result = await repository.markNotificationAsRead(
            'test_token', 'notification_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Alerta no encontrada'));
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
        final result = await repository.markNotificationAsRead(
            'test_token', 'notification_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('No autorizado'));
      });

      test('should handle receive timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.markNotificationAsRead(
            'test_token', 'notification_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Tiempo de respuesta agotado'));
      });
    });
  });
}
