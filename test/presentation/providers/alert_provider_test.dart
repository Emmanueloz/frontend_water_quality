import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/core/enums/alert_type.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/alert_repo.dart';
import 'package:frontend_water_quality/presentation/providers/alert_provider.dart';
import '../../mocks/mocks.dart';

class MockAlertRepository implements AlertRepository {
  Result<List<Alert>>? mockListAlertsResult;
  Result<Alert>? mockGetAlertDetailsResult;
  Result<Alert>? mockCreateAlertResult;
  Result<Alert>? mockUpdateAlertResult;
  Result<bool>? mockDeleteAlertResult;
  Result<List<Alert>>? mockGetAlertNotificationsResult;
  Result<bool>? mockMarkNotificationAsReadResult;
  int callCount = 0;

  void reset() {
    mockListAlertsResult = null;
    mockGetAlertDetailsResult = null;
    mockCreateAlertResult = null;
    mockUpdateAlertResult = null;
    mockDeleteAlertResult = null;
    mockGetAlertNotificationsResult = null;
    mockMarkNotificationAsReadResult = null;
    callCount = 0;
  }

  @override
  Future<Result<List<Alert>>> listAlerts(
      String userToken, String workspaceId) async {
    callCount++;
    return mockListAlertsResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<Alert>> getAlertDetails(
      String userToken, String alertId) async {
    callCount++;
    return mockGetAlertDetailsResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<Alert>> createAlert(String userToken, Alert alertData) async {
    callCount++;
    return mockCreateAlertResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<Alert>> updateAlert(
      String userToken, String alertId, Alert alertData) async {
    callCount++;
    return mockUpdateAlertResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<bool>> deleteAlert(String userToken, String alertId) async {
    callCount++;
    return mockDeleteAlertResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<List<Alert>>> getAlertNotifications(String userToken) async {
    callCount++;
    return mockGetAlertNotificationsResult ??
        Result.failure('Mock not configured');
  }

  @override
  Future<Result<bool>> markNotificationAsRead(
      String userToken, String notificationId) async {
    callCount++;
    return mockMarkNotificationAsReadResult ??
        Result.failure('Mock not configured');
  }
}

void main() {
  group('AlertProvider Tests', () {
    late MockAlertRepository mockRepository;
    late MockAuthProvider mockAuthProvider;
    late AlertProvider provider;

    // Test data
    final testUser = User(uid: 'user_1', email: 'test@example.com');
    const testToken = 'test_token';
    const testWorkspaceId = 'workspace_1';

    final testAlert = Alert(
      id: 'alert_1',
      title: 'High Temperature Alert',
      type: AlertType.good,
      workspaceId: testWorkspaceId,
      meterId: 'meter_1',
      parameters: Parameter(
        ph: RangeValue(min: 6.5, max: 8.5),
        temperature: RangeValue(min: 0.0, max: 30.0),
        tds: RangeValue(min: 0.0, max: 500.0),
        conductivity: RangeValue(min: 0.0, max: 1000.0),
        turbidity: RangeValue(min: 0.0, max: 5.0),
      ),
    );

    final testAlert2 = Alert(
      id: 'alert_2',
      title: 'Low pH Alert',
      type: AlertType.moderate,
      workspaceId: testWorkspaceId,
      meterId: 'meter_1',
    );

    setUp(() {
      mockRepository = MockAlertRepository();
      mockAuthProvider = MockAuthProvider();
      provider = AlertProvider(mockRepository, mockAuthProvider);
    });

    tearDown(() {
      mockRepository.reset();
    });

    group('loadAlerts', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.loadAlerts();

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.alerts, isEmpty);
        expect(provider.isLoading, isFalse);
      });

      test('should fail when workspace ID is not set', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);

        // Act
        await provider.loadAlerts();

        // Assert
        expect(provider.errorMessage, contains('Workspace ID no disponible'));
        expect(provider.alerts, isEmpty);
        expect(provider.isLoading, isFalse);
      });

      test('should skip loading when recharge is false', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListAlertsResult = Result.success([testAlert]);

        // First load
        await provider.loadAlerts();
        expect(provider.alerts.length, equals(1));

        // Reset mock
        mockRepository.reset();

        // Act - second load without forcing reload
        await provider.loadAlerts();

        // Assert - should not call repository again
        expect(mockRepository.callCount, equals(0));
      });

      test('should load alerts successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListAlertsResult =
            Result.success([testAlert, testAlert2]);

        // Act
        await provider.loadAlerts();

        // Assert
        expect(provider.alerts.length, equals(2));
        expect(provider.alerts[0].id, equals('alert_1'));
        expect(provider.alerts[1].id, equals('alert_2'));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
        expect(provider.recharge, isFalse);
      });

      test('should handle error when loading alerts fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListAlertsResult =
            Result.failure('Error al cargar alertas');

        // Act
        await provider.loadAlerts();

        // Assert
        expect(provider.alerts, isEmpty);
        expect(provider.errorMessage, equals('Error al cargar alertas'));
        expect(provider.isLoading, isFalse);
      });

      test('should handle exception during loading', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListAlertsResult =
            Result.failure('Mock not configured');

        // Act
        await provider.loadAlerts();

        // Assert
        expect(provider.alerts, isEmpty);
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });

      test('should set loading state during operation', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListAlertsResult = Result.success([testAlert]);

        // Act
        final future = provider.loadAlerts();

        // Assert - loading should be true during operation
        expect(provider.isLoading, isTrue);

        await future;

        // Assert - loading should be false after operation
        expect(provider.isLoading, isFalse);
      });
    });

    group('getAlertDetails', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.getAlertDetails('alert_1');

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.selectedAlert, isNull);
        expect(provider.isLoading, isFalse);
      });

      test('should get alert details successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetAlertDetailsResult = Result.success(testAlert);

        // Act
        await provider.getAlertDetails('alert_1');

        // Assert
        expect(provider.selectedAlert, isNotNull);
        expect(provider.selectedAlert!.id, equals('alert_1'));
        expect(provider.selectedAlert!.title, equals('High Temperature Alert'));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
      });

      test('should handle error when getting alert details fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetAlertDetailsResult =
            Result.failure('Alerta no encontrada');

        // Act
        await provider.getAlertDetails('alert_1');

        // Assert
        expect(provider.selectedAlert, isNull);
        expect(provider.errorMessage, equals('Alerta no encontrada'));
        expect(provider.isLoading, isFalse);
      });

      test('should handle exception during get details', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetAlertDetailsResult =
            Result.failure('Mock not configured');

        // Act
        await provider.getAlertDetails('alert_1');

        // Assert
        expect(provider.selectedAlert, isNull);
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });
    });

    group('createAlert', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.createAlert(testAlert);

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.alerts, isEmpty);
        expect(provider.isLoading, isFalse);
      });

      test('should create alert successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        final newAlert = Alert(
          id: 'alert_3',
          title: 'New Alert',
          type: AlertType.good,
          workspaceId: testWorkspaceId,
        );
        mockRepository.mockCreateAlertResult = Result.success(newAlert);

        // Act
        await provider.createAlert(newAlert);

        // Assert
        expect(provider.alerts.length, equals(1));
        expect(provider.alerts[0].id, equals('alert_3'));
        expect(provider.alerts[0].title, equals('New Alert'));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
        expect(provider.recharge, isFalse);
      });

      test('should handle error when creating alert fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockCreateAlertResult =
            Result.failure('Error al crear alerta');

        // Act
        await provider.createAlert(testAlert);

        // Assert
        expect(provider.alerts, isEmpty);
        expect(provider.errorMessage, equals('Error al crear alerta'));
        expect(provider.isLoading, isFalse);
      });

      test('should handle exception during create', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockCreateAlertResult =
            Result.failure('Mock not configured');

        // Act
        await provider.createAlert(testAlert);

        // Assert
        expect(provider.alerts, isEmpty);
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });
    });

    group('updateAlert', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.updateAlert('alert_1', testAlert);

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.isLoading, isFalse);
      });

      test('should fail when alert ID is null', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);

        // Act
        await provider.updateAlert(null, testAlert);

        // Assert
        expect(provider.errorMessage, contains('Alert ID no proporcionado'));
        expect(provider.isLoading, isFalse);
      });

      test('should update alert successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListAlertsResult = Result.success([testAlert]);
        await provider.loadAlerts();

        final updatedAlert = Alert(
          id: 'alert_1',
          title: 'Updated Alert',
          type: AlertType.moderate,
          workspaceId: testWorkspaceId,
        );
        mockRepository.mockUpdateAlertResult = Result.success(updatedAlert);

        // Act
        await provider.updateAlert('alert_1', updatedAlert);

        // Assert
        expect(provider.alerts.length, equals(1));
        expect(provider.alerts[0].title, equals('Updated Alert'));
        expect(provider.alerts[0].type, equals(AlertType.moderate));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
      });

      test('should handle error when updating alert fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockUpdateAlertResult =
            Result.failure('Error al actualizar');

        // Act
        await provider.updateAlert('alert_1', testAlert);

        // Assert
        expect(provider.errorMessage, equals('Error al actualizar'));
        expect(provider.isLoading, isFalse);
      });

      test('should handle exception during update', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockUpdateAlertResult =
            Result.failure('Mock not configured');

        // Act
        await provider.updateAlert('alert_1', testAlert);

        // Assert
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });
    });

    group('deleteAlert', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.deleteAlert('alert_1');

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.isLoading, isFalse);
      });

      test('should delete alert successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListAlertsResult =
            Result.success([testAlert, testAlert2]);
        await provider.loadAlerts();

        mockRepository.mockDeleteAlertResult = Result.success(true);

        // Act
        await provider.deleteAlert('alert_1');

        // Assert
        expect(provider.alerts.length, equals(1));
        expect(provider.alerts[0].id, equals('alert_2'));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
      });

      test('should clear selected alert when deleting it', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListAlertsResult = Result.success([testAlert]);
        await provider.loadAlerts();

        provider.setSelectedAlert(testAlert);
        expect(provider.selectedAlert, isNotNull);

        mockRepository.mockDeleteAlertResult = Result.success(true);

        // Act
        await provider.deleteAlert('alert_1');

        // Assert
        expect(provider.selectedAlert, isNull);
        expect(provider.alerts, isEmpty);
      });

      test('should handle error when deleting alert fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockDeleteAlertResult =
            Result.failure('Error al eliminar');

        // Act
        await provider.deleteAlert('alert_1');

        // Assert
        expect(provider.errorMessage, equals('Error al eliminar'));
        expect(provider.isLoading, isFalse);
      });

      test('should handle exception during delete', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockDeleteAlertResult =
            Result.failure('Mock not configured');

        // Act
        await provider.deleteAlert('alert_1');

        // Assert
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });
    });

    group('loadAlertNotifications', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.loadAlertNotifications();

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.isLoading, isFalse);
      });

      test('should load alert notifications successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetAlertNotificationsResult =
            Result.success([testAlert, testAlert2]);

        // Act
        await provider.loadAlertNotifications();

        // Assert
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
      });

      test('should handle error when loading notifications fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetAlertNotificationsResult =
            Result.failure('Error al cargar notificaciones');

        // Act
        await provider.loadAlertNotifications();

        // Assert
        expect(provider.errorMessage, equals('Error al cargar notificaciones'));
        expect(provider.isLoading, isFalse);
      });

      test('should handle exception during load notifications', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetAlertNotificationsResult =
            Result.failure('Mock not configured');

        // Act
        await provider.loadAlertNotifications();

        // Assert
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });
    });

    group('markNotificationAsRead', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.markNotificationAsRead('notification_1');

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.isLoading, isFalse);
      });

      test('should mark notification as read successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockMarkNotificationAsReadResult = Result.success(true);

        // Act
        await provider.markNotificationAsRead('notification_1');

        // Assert
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
      });

      test('should handle error when marking notification fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockMarkNotificationAsReadResult =
            Result.failure('Error al marcar como leída');

        // Act
        await provider.markNotificationAsRead('notification_1');

        // Assert
        expect(provider.errorMessage, equals('Error al marcar como leída'));
        expect(provider.isLoading, isFalse);
      });

      test('should handle exception during mark as read', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockMarkNotificationAsReadResult =
            Result.failure('Mock not configured');

        // Act
        await provider.markNotificationAsRead('notification_1');

        // Assert
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });
    });

    group('state management', () {
      test('should set workspace ID and trigger reload', () {
        // Act
        provider.setWorkspaceId(testWorkspaceId);

        // Assert
        expect(provider.currentWorkspaceId, equals(testWorkspaceId));
        expect(provider.recharge, isTrue);
      });

      test('should not trigger reload when setting same workspace ID',
          () async {
        // Arrange
        provider.setWorkspaceId(testWorkspaceId);

        // Reset recharge flag by loading
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListAlertsResult = Result.success([testAlert]);
        await provider.loadAlerts();

        expect(provider.recharge, isFalse);

        // Act - set same workspace ID again
        provider.setWorkspaceId(testWorkspaceId);

        // Assert - should not trigger reload
        expect(provider.recharge, isFalse);
      });

      test('should force reload', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListAlertsResult = Result.success([testAlert]);
        await provider.loadAlerts();

        // Reset mock
        mockRepository.reset();
        mockRepository.mockListAlertsResult = Result.success([testAlert]);

        // Act
        provider.forceReload();

        // Assert
        expect(provider.recharge, isTrue);
        // Wait for async operation
        await Future.delayed(Duration(milliseconds: 100));
        expect(mockRepository.callCount, equals(1));
      });

      test('should clean state', () {
        // Arrange
        provider.setWorkspaceId(testWorkspaceId);
        provider.setSelectedAlert(testAlert);

        // Act
        provider.clean();

        // Assert
        expect(provider.alerts, isEmpty);
        expect(provider.selectedAlert, isNull);
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
      });

      test('should clean error message', () async {
        // Arrange
        await provider.loadAlerts(); // This will set an error

        // Act
        provider.cleanError();

        // Assert
        expect(provider.errorMessage, isNull);
      });

      test('should set selected alert', () {
        // Act
        provider.setSelectedAlert(testAlert);

        // Assert
        expect(provider.selectedAlert, isNotNull);
        expect(provider.selectedAlert!.id, equals('alert_1'));
      });

      test('should clear selected alert', () {
        // Arrange
        provider.setSelectedAlert(testAlert);

        // Act
        provider.setSelectedAlert(null);

        // Assert
        expect(provider.selectedAlert, isNull);
      });
    });
  });
}
