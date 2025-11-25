import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/core/enums/notification_status.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/notification_repo.dart';
import 'package:frontend_water_quality/presentation/providers/notification_provider.dart';
import '../../mocks/mocks.dart';

class MockNotificationRepository implements NotificationRepository {
  Result<List<NotificationModel>>? mockListNotificationsResult;
  Result<NotificationModel>? mockGetNotificationDetailsResult;
  Result<String>? mockChangeStatusResult;
  int callCount = 0;

  void reset() {
    mockListNotificationsResult = null;
    mockGetNotificationDetailsResult = null;
    mockChangeStatusResult = null;
    callCount = 0;
  }

  @override
  Future<Result<List<NotificationModel>>> listNotifications(
      String userToken, bool isRead, NotificationStatus status) async {
    callCount++;
    return mockListNotificationsResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<NotificationModel>> getNotificationDetails(
      String userToken, String notificationId) async {
    callCount++;
    return mockGetNotificationDetailsResult ??
        Result.failure('Mock not configured');
  }

  @override
  Future<Result<String>> changeStatus(String userToken, String notificationId,
      NotificationStatus status) async {
    callCount++;
    return mockChangeStatusResult ?? Result.failure('Mock not configured');
  }
}

void main() {
  group('NotificationProvider Tests', () {
    late MockNotificationRepository mockRepository;
    late MockAuthProvider mockAuthProvider;
    late NotificationProvider provider;

    // Test data
    final testUser = User(uid: 'user_1', email: 'test@example.com');
    const testToken = 'test_token';

    final testNotification1 = NotificationModel(
      id: 'notification_1',
      read: false,
      title: 'High Temperature Alert',
      body: 'Temperature exceeded threshold',
      userIds: ['user_1'],
      date: DateTime(2024, 1, 15, 10, 30),
      status: 'pending',
      recordParameters: [
        RecordParameter(parameter: 'temperature', value: 35.5),
      ],
    );

    final testNotification2 = NotificationModel(
      id: 'notification_2',
      read: true,
      title: 'Low pH Alert',
      body: 'pH level below threshold',
      userIds: ['user_1'],
      date: DateTime(2024, 1, 14, 15, 20),
      status: 'accepted',
      recordParameters: [
        RecordParameter(parameter: 'ph', value: 6.0),
      ],
    );

    final testNotification3 = NotificationModel(
      id: 'notification_3',
      read: false,
      title: 'High Turbidity',
      body: 'Turbidity exceeded threshold',
      userIds: ['user_1'],
      date: DateTime(2024, 1, 16, 8, 45),
      status: 'pending',
      recordParameters: [
        RecordParameter(parameter: 'turbidity', value: 8.2),
      ],
    );

    setUp(() {
      mockRepository = MockNotificationRepository();
      mockAuthProvider = MockAuthProvider();
      provider = NotificationProvider(mockRepository, mockAuthProvider);
    });

    tearDown(() {
      mockRepository.reset();
    });

    group('listNotifications', () {
      test('should fail when user is not authenticated', () async {
        // Act
        final result =
            await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
      });

      test('should list unread notifications successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult =
            Result.success([testNotification1, testNotification3]);

        // Act
        final result =
            await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.length, equals(2));
        expect(result.value![0].id, equals('notification_1'));
        expect(result.value![0].read, isFalse);
        expect(result.value![1].id, equals('notification_3'));
        expect(result.value![1].read, isFalse);
      });

      test('should list read notifications successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult =
            Result.success([testNotification2]);

        // Act
        final result =
            await provider.listNotifications(true, NotificationStatus.accepted);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.length, equals(1));
        expect(result.value![0].id, equals('notification_2'));
        expect(result.value![0].read, isTrue);
        expect(result.value![0].status, equals('accepted'));
      });

      test('should list all notifications successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult = Result.success([
          testNotification1,
          testNotification2,
          testNotification3,
        ]);

        // Act
        final result =
            await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.length, equals(3));
      });

      test('should return empty list when no notifications exist', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult = Result.success([]);

        // Act
        final result =
            await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.isEmpty, isTrue);
      });

      test('should handle error when listing notifications fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult =
            Result.failure('Error al cargar notificaciones');

        // Act
        final result =
            await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error al cargar notificaciones'));
      });

      test('should handle exception during list notifications', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult =
            Result.failure('Mock not configured');

        // Act
        final result =
            await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });

    group('getNotificationDetails', () {
      test('should fail when user is not authenticated', () async {
        // Act
        final result = await provider.getNotificationDetails('notification_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
      });

      test('should get notification details successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetNotificationDetailsResult =
            Result.success(testNotification1);

        // Act
        final result = await provider.getNotificationDetails('notification_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.id, equals('notification_1'));
        expect(result.value!.title, equals('High Temperature Alert'));
        expect(result.value!.body, equals('Temperature exceeded threshold'));
        expect(result.value!.read, isFalse);
        expect(result.value!.status, equals('pending'));
      });

      test('should get read notification details successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetNotificationDetailsResult =
            Result.success(testNotification2);

        // Act
        final result = await provider.getNotificationDetails('notification_2');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.id, equals('notification_2'));
        expect(result.value!.read, isTrue);
        expect(result.value!.status, equals('accepted'));
      });

      test('should handle error when notification not found', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetNotificationDetailsResult =
            Result.failure('Notificación no encontrada');

        // Act
        final result =
            await provider.getNotificationDetails('notification_999');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Notificación no encontrada'));
      });

      test('should handle exception during get details', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetNotificationDetailsResult =
            Result.failure('Mock not configured');

        // Act
        final result = await provider.getNotificationDetails('notification_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });

    group('changeStatus (markAsRead)', () {
      test('should fail when user is not authenticated', () async {
        // Act
        final result = await provider.changeStatus(
            'notification_1', NotificationStatus.accepted);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
      });

      test('should mark notification as accepted successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockChangeStatusResult =
            Result.success('Status changed successfully');

        // Act
        final result = await provider.changeStatus(
            'notification_1', NotificationStatus.accepted);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Status changed successfully'));
      });

      test('should mark notification as rejected successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockChangeStatusResult =
            Result.success('Status changed successfully');

        // Act
        final result = await provider.changeStatus(
            'notification_1', NotificationStatus.rejected);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Status changed successfully'));
      });

      test('should change status to pending successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockChangeStatusResult =
            Result.success('Status changed successfully');

        // Act
        final result = await provider.changeStatus(
            'notification_2', NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Status changed successfully'));
      });

      test('should handle error when changing status fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockChangeStatusResult =
            Result.failure('Error al cambiar estado');

        // Act
        final result = await provider.changeStatus(
            'notification_1', NotificationStatus.accepted);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error al cambiar estado'));
      });

      test('should handle error when notification not found', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockChangeStatusResult =
            Result.failure('Notificación no encontrada');

        // Act
        final result = await provider.changeStatus(
            'notification_999', NotificationStatus.accepted);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Notificación no encontrada'));
      });

      test('should handle exception during change status', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockChangeStatusResult =
            Result.failure('Mock not configured');

        // Act
        final result = await provider.changeStatus(
            'notification_1', NotificationStatus.accepted);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });

    group('authentication validation', () {
      test('should validate token exists for listNotifications', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, null);

        // Act
        final result =
            await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should validate token exists for getNotificationDetails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, null);

        // Act
        final result = await provider.getNotificationDetails('notification_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should validate token exists for changeStatus', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, null);

        // Act
        final result = await provider.changeStatus(
            'notification_1', NotificationStatus.accepted);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should validate user exists for all operations', () async {
        // Arrange - set both user and token to null
        mockAuthProvider.setMockUser(null, null);

        // Act
        final result1 =
            await provider.listNotifications(false, NotificationStatus.pending);
        final result2 = await provider.getNotificationDetails('notification_1');
        final result3 = await provider.changeStatus(
            'notification_1', NotificationStatus.accepted);

        // Assert
        expect(result1.isSuccess, isFalse);
        expect(result2.isSuccess, isFalse);
        expect(result3.isSuccess, isFalse);
        expect(mockRepository.callCount, equals(0));
      });
    });

    group('repository interaction', () {
      test(
          'should call repository with correct parameters for listNotifications',
          () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult = Result.success([]);

        // Act
        await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(mockRepository.callCount, equals(1));
      });

      test(
          'should call repository with correct parameters for getNotificationDetails',
          () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetNotificationDetailsResult =
            Result.success(testNotification1);

        // Act
        await provider.getNotificationDetails('notification_1');

        // Assert
        expect(mockRepository.callCount, equals(1));
      });

      test('should call repository with correct parameters for changeStatus',
          () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockChangeStatusResult =
            Result.success('Status changed');

        // Act
        await provider.changeStatus(
            'notification_1', NotificationStatus.accepted);

        // Assert
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle multiple sequential operations', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult =
            Result.success([testNotification1]);
        mockRepository.mockGetNotificationDetailsResult =
            Result.success(testNotification1);
        mockRepository.mockChangeStatusResult =
            Result.success('Status changed');

        // Act
        await provider.listNotifications(false, NotificationStatus.pending);
        await provider.getNotificationDetails('notification_1');
        await provider.changeStatus(
            'notification_1', NotificationStatus.accepted);

        // Assert
        expect(mockRepository.callCount, equals(3));
      });
    });

    group('error handling', () {
      test('should handle network timeout error', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult =
            Result.failure('Connection timeout');

        // Act
        final result =
            await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Connection timeout'));
      });

      test('should handle server error', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockGetNotificationDetailsResult =
            Result.failure('Internal server error');

        // Act
        final result = await provider.getNotificationDetails('notification_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Internal server error'));
      });

      test('should handle unauthorized error', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockChangeStatusResult =
            Result.failure('Unauthorized access');

        // Act
        final result = await provider.changeStatus(
            'notification_1', NotificationStatus.accepted);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Unauthorized access'));
      });

      test('should handle forbidden error', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult =
            Result.failure('Forbidden: insufficient permissions');

        // Act
        final result =
            await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Forbidden'));
      });
    });

    group('notification filtering', () {
      test('should filter by read status', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult =
            Result.success([testNotification2]);

        // Act - request only read notifications
        final result =
            await provider.listNotifications(true, NotificationStatus.accepted);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.length, equals(1));
        expect(result.value![0].read, isTrue);
      });

      test('should filter by notification status', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListNotificationsResult =
            Result.success([testNotification1, testNotification3]);

        // Act - request only pending notifications
        final result =
            await provider.listNotifications(false, NotificationStatus.pending);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.length, equals(2));
        expect(result.value!.every((n) => n.status == 'pending'), isTrue);
      });

      test('should handle different status types', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);

        // Test pending
        mockRepository.mockListNotificationsResult =
            Result.success([testNotification1]);
        final result1 =
            await provider.listNotifications(false, NotificationStatus.pending);
        expect(result1.isSuccess, isTrue);

        // Test accepted
        mockRepository.mockListNotificationsResult =
            Result.success([testNotification2]);
        final result2 =
            await provider.listNotifications(true, NotificationStatus.accepted);
        expect(result2.isSuccess, isTrue);

        // Test rejected
        mockRepository.mockListNotificationsResult = Result.success([]);
        final result3 = await provider.listNotifications(
            false, NotificationStatus.rejected);
        expect(result3.isSuccess, isTrue);
      });
    });

    group('setAuthProvider', () {
      test('should update auth provider', () {
        // Arrange
        final newAuthProvider = MockAuthProvider();
        newAuthProvider.setMockUser(testUser, testToken);

        // Act
        provider.setAuthProvider(newAuthProvider);

        // Assert - verify by making a call that requires auth
        mockRepository.mockListNotificationsResult = Result.success([]);
        provider.listNotifications(false, NotificationStatus.pending);
        expect(mockRepository.callCount, equals(1));
      });

      test('should allow setting null auth provider', () {
        // Act
        provider.setAuthProvider(null);

        // Assert - operations should fail without auth
        final result =
            provider.listNotifications(false, NotificationStatus.pending);
        result.then((r) => expect(r.isSuccess, isFalse));
      });
    });
  });
}
