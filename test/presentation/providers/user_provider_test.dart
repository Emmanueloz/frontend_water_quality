import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/user_repo.dart';
import 'package:frontend_water_quality/presentation/providers/user_provider.dart';
import 'package:frontend_water_quality/core/enums/roles.dart';
import '../../mocks/mocks.dart';

class MockUserRepository implements UserRepo {
  Result<User>? mockGetUserResult;
  Result<BaseResponse>? mockUpdateResult;
  Result<BaseResponse>? mockUpdatePasswordResult;

  int callCount = 0;

  void reset() {
    mockGetUserResult = null;
    mockUpdateResult = null;
    mockUpdatePasswordResult = null;
    callCount = 0;
  }

  @override
  Future<Result<User>> getUser(String userToken) async {
    callCount++;
    return mockGetUserResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<BaseResponse>> update(String userToken, User user) async {
    callCount++;
    return mockUpdateResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<BaseResponse>> updatePassword(
      String userToken, String newPassword) async {
    callCount++;
    return mockUpdatePasswordResult ?? Result.failure('Mock not configured');
  }
}

void main() {
  group('UserProvider Tests', () {
    late MockUserRepository mockUserRepo;
    late MockAuthProvider mockAuthProvider;
    late UserProvider provider;

    // Test data
    final testUser = User(
      uid: 'user_1',
      email: 'test@example.com',
      username: 'testuser',
      phone: '1234567890',
      rol: AppRoles.admin,
    );

    final updatedUser = User(
      uid: 'user_1',
      email: 'updated@example.com',
      username: 'updateduser',
      phone: '9876543210',
      rol: AppRoles.client,
    );

    setUp(() {
      mockUserRepo = MockUserRepository();
      mockAuthProvider = MockAuthProvider();
      provider = UserProvider(mockUserRepo, mockAuthProvider);
    });

    tearDown(() {
      mockUserRepo.reset();
      mockAuthProvider.reset();
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        // Assert
        expect(provider.isAuthenticated, isFalse);
        expect(provider.user, isNull);
        expect(provider.errorMessage, isNull);
      });
    });

    group('getUser', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        final result = await provider.getUser();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('User not authenticated'));
        expect(mockUserRepo.callCount, equals(0));
      });

      test('should get user successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockGetUserResult = Result.success(testUser);

        // Act
        final result = await provider.getUser();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isNotNull);
        expect(result.value!.uid, equals('user_1'));
        expect(result.value!.email, equals('test@example.com'));
        expect(result.value!.username, equals('testuser'));
        expect(mockUserRepo.callCount, equals(1));
      });

      test('should handle repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockGetUserResult = Result.failure('User not found');

        // Act
        final result = await provider.getUser();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('User not found'));
        expect(mockUserRepo.callCount, equals(1));
      });

      test('should handle exception during user fetch', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockGetUserResult = null; // Will throw

        // Act
        final result = await provider.getUser();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });
    });

    group('updateUser', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        final result = await provider.updateUser(updatedUser);

        // Assert
        expect(result, equals('User not authenticated'));
        expect(provider.user, isNull);
        expect(mockUserRepo.callCount, equals(0));
      });

      test('should update user successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'User updated successfully');
        mockUserRepo.mockUpdateResult = Result.success(updateResponse);
        bool listenerCalled = false;

        provider.addListener(() {
          listenerCalled = true;
        });

        // Act
        final result = await provider.updateUser(updatedUser);

        // Assert
        expect(result, equals(null));
        expect(provider.user, equals(updatedUser));
        expect(provider.user!.email, equals('updated@example.com'));
        expect(provider.user!.username, equals('updateduser'));
        expect(provider.user!.phone, equals('9876543210'));
        expect(provider.errorMessage, isNull);
        expect(listenerCalled, isTrue);
        expect(mockUserRepo.callCount, equals(1));
      });

      test('should update auth provider user data on success', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'User updated successfully');
        mockUserRepo.mockUpdateResult = Result.success(updateResponse);

        // Act
        await provider.updateUser(updatedUser);

        // Assert
        expect(mockAuthProvider.updateUserDataCalled, isTrue);
      });

      test('should handle update failure with error message', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockUpdateResult = Result.failure('Invalid user data');

        // Act
        final result = await provider.updateUser(updatedUser);

        // Assert
        expect(result, equals('Invalid user data'));
        expect(provider.errorMessage, equals('Invalid user data'));
        expect(provider.user, isNull);
        expect(mockUserRepo.callCount, equals(1));
      });

      test('should notify listeners on update success', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'User updated successfully');
        mockUserRepo.mockUpdateResult = Result.success(updateResponse);
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.updateUser(updatedUser);

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should handle exception during update', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockUpdateResult = null; // Will throw

        // Act
        final result = await provider.updateUser(updatedUser);

        // Assert
        expect(result, isNotNull);
        expect(provider.errorMessage, isNotNull);
      });

      test('should validate user data before update', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final invalidUser = User(
          uid: 'user_1',
          email: 'invalid-email',
          username: '',
          rol: AppRoles.client,
        );
        mockUserRepo.mockUpdateResult = Result.failure('Datos inválidos');

        // Act
        final result = await provider.updateUser(invalidUser);

        // Assert
        expect(result, equals('Datos inválidos'));
        expect(provider.errorMessage, equals('Datos inválidos'));
      });
    });

    group('updatePassword', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        final result = await provider.updatePassword('newPassword123');

        // Assert
        expect(result, equals('User not authenticated'));
        expect(mockUserRepo.callCount, equals(0));
      });

      test('should update password successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'Password updated successfully');
        mockUserRepo.mockUpdatePasswordResult = Result.success(updateResponse);

        // Act
        final result = await provider.updatePassword('newPassword123');

        // Assert
        expect(result, null);
        expect(provider.errorMessage, isNull);
        expect(mockUserRepo.callCount, equals(1));
      });

      test('should handle password update failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockUpdatePasswordResult =
            Result.failure('Password too weak');

        // Act
        final result = await provider.updatePassword('weak');

        // Assert
        expect(result, equals('Password too weak'));
        expect(provider.errorMessage, equals('Password too weak'));
        expect(mockUserRepo.callCount, equals(1));
      });

      test('should handle exception during password update', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockUpdatePasswordResult = null; // Will throw

        // Act
        final result = await provider.updatePassword('newPassword123');

        // Assert
        expect(result, isNotNull);
        expect(provider.errorMessage, isNotNull);
      });

      test('should validate password strength', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockUpdatePasswordResult =
            Result.failure('La contraseña debe tener al menos 8 caracteres');

        // Act
        final result = await provider.updatePassword('short');

        // Assert
        expect(
            result, equals('La contraseña debe tener al menos 8 caracteres'));
        expect(provider.errorMessage,
            equals('La contraseña debe tener al menos 8 caracteres'));
      });
    });

    group('clean', () {
      test('should clear all user state', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'User updated successfully');
        mockUserRepo.mockUpdateResult = Result.success(updateResponse);
        await provider.updateUser(updatedUser);
        expect(provider.user, isNotNull);

        // Act
        provider.clean();

        // Assert
        expect(provider.isAuthenticated, isFalse);
        expect(provider.user, isNull);
        expect(provider.errorMessage, isNull);
      });

      test('should notify listeners when cleaning state', () {
        // Arrange
        provider.user = testUser;
        provider.isAuthenticated = true;
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        provider.clean();

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('Profile State Management', () {
      test('should maintain user state across operations', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'User updated successfully');
        mockUserRepo.mockUpdateResult = Result.success(updateResponse);

        // Act - Update user
        await provider.updateUser(updatedUser);
        expect(provider.user, equals(updatedUser));

        // Update password
        final passwordResponse =
            BaseResponse(message: 'Password updated successfully');
        mockUserRepo.mockUpdatePasswordResult =
            Result.success(passwordResponse);
        await provider.updatePassword('newPassword123');

        // Assert - User data still maintained
        expect(provider.user, equals(updatedUser));
        expect(provider.user!.email, equals('updated@example.com'));
      });

      test('should clear error message on successful operation after failure',
          () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');

        // First operation fails
        mockUserRepo.mockUpdateResult = Result.failure('Update failed');
        await provider.updateUser(updatedUser);
        expect(provider.errorMessage, equals('Update failed'));

        // Second operation succeeds
        final updateResponse =
            BaseResponse(message: 'User updated successfully');
        mockUserRepo.mockUpdateResult = Result.success(updateResponse);
        await provider.updateUser(updatedUser);

        // Assert - Error cleared
        expect(provider.errorMessage, isNull);
      });
    });

    group('Authentication Integration', () {
      test('should work with auth provider token', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'auth_token_123');
        mockUserRepo.mockGetUserResult = Result.success(testUser);

        // Act
        final result = await provider.getUser();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(mockUserRepo.callCount, equals(1));
      });

      test('should handle auth provider without token', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        final getUserResult = await provider.getUser();
        final updateResult = await provider.updateUser(updatedUser);
        final passwordResult = await provider.updatePassword('newPassword123');

        // Assert
        expect(getUserResult.isSuccess, isFalse);
        expect(updateResult, equals('User not authenticated'));
        expect(passwordResult, equals('User not authenticated'));
        expect(mockUserRepo.callCount, equals(0));
      });

      test('should sync user data with auth provider on update', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockAuthProvider.setMockUser(testUser, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'User updated successfully');
        mockUserRepo.mockUpdateResult = Result.success(updateResponse);

        // Act
        await provider.updateUser(updatedUser);

        // Assert
        expect(mockAuthProvider.updateUserDataCalled, isTrue);
        expect(provider.user, equals(updatedUser));
      });
    });

    group('Error Handling', () {
      test('should set error message on repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockUpdateResult = Result.failure('Network error');

        // Act
        await provider.updateUser(updatedUser);

        // Assert
        expect(provider.errorMessage, equals('Network error'));
      });

      test('should set error message on password update failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockUpdatePasswordResult =
            Result.failure('Invalid password');

        // Act
        await provider.updatePassword('newPassword123');

        // Assert
        expect(provider.errorMessage, equals('Invalid password'));
      });

      test('should handle multiple consecutive errors', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');

        // First error
        mockUserRepo.mockUpdateResult = Result.failure('Error 1');
        await provider.updateUser(updatedUser);
        expect(provider.errorMessage, equals('Error 1'));

        // Second error
        mockUserRepo.mockUpdatePasswordResult = Result.failure('Error 2');
        await provider.updatePassword('newPassword123');
        expect(provider.errorMessage, equals('Error 2'));
      });

      test('should clear error on clean', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockUpdateResult = Result.failure('Update failed');
        await provider.updateUser(updatedUser);
        expect(provider.errorMessage, isNotNull);

        // Act
        provider.clean();

        // Assert
        expect(provider.errorMessage, isNull);
      });
    });

    group('Listener Notifications', () {
      test('should notify listeners on successful user update', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'User updated successfully');
        mockUserRepo.mockUpdateResult = Result.success(updateResponse);
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.updateUser(updatedUser);

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should notify listeners on clean', () {
        // Arrange
        provider.user = testUser;
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        provider.clean();

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should not notify listeners on getUser', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockUserRepo.mockGetUserResult = Result.success(testUser);
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.getUser();

        // Assert
        expect(notifyCount, equals(0));
      });
    });
  });
}
