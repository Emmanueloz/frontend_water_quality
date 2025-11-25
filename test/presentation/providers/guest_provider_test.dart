import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/guest_repo.dart';
import 'package:frontend_water_quality/presentation/providers/guest_provider.dart';
import '../../mocks/mocks.dart';


class MockGuestRepository implements GuestRepository {
  Result<List<Guest>>? mockListGuestsResult;
  Result<Guest>? mockInviteGuestResult;
  Result<Guest>? mockUpdateGuestRoleResult;
  Result<bool>? mockDeleteGuestResult;
  int callCount = 0;

  void reset() {
    mockListGuestsResult = null;
    mockInviteGuestResult = null;
    mockUpdateGuestRoleResult = null;
    mockDeleteGuestResult = null;
    callCount = 0;
  }

  @override
  Future<Result<List<Guest>>> listGuests(
      String userToken, String workspaceId) async {
    callCount++;
    return mockListGuestsResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<Guest>> inviteGuest(
      String userToken, String workspaceId, String email, String role) async {
    callCount++;
    return mockInviteGuestResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<Guest>> updateGuestRole(String userToken, String workspaceId,
      String guestId, String role) async {
    callCount++;
    return mockUpdateGuestRoleResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<bool>> deleteGuest(
      String userToken, String workspaceId, String guestId) async {
    callCount++;
    return mockDeleteGuestResult ?? Result.failure('Mock not configured');
  }
}

void main() {
  group('GuestProvider Tests', () {
    late MockGuestRepository mockRepository;
    late MockAuthProvider mockAuthProvider;
    late GuestProvider provider;

    // Test data
    final testUser = User(uid: 'user_1', email: 'test@example.com');
    const testToken = 'test_token';
    const testWorkspaceId = 'workspace_1';

    final testGuest1 = Guest(
      id: 'guest_1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      role: 'viewer',
    );

    final testGuest2 = Guest(
      id: 'guest_2',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      role: 'editor',
    );

    setUp(() {
      mockRepository = MockGuestRepository();
      mockAuthProvider = MockAuthProvider();
      provider = GuestProvider(mockRepository, mockAuthProvider);
    });

    tearDown(() {
      mockRepository.reset();
    });

    group('loadGuests', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.loadGuests(testWorkspaceId);

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.guests, isEmpty);
        expect(provider.isLoading, isFalse);
      });

      test('should skip loading when recharge is false', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListGuestsResult = Result.success([testGuest1]);

        // First load
        await provider.loadGuests(testWorkspaceId);
        expect(provider.guests.length, equals(1));

        // Reset mock
        mockRepository.reset();

        // Act - second load without forcing reload
        await provider.loadGuests(testWorkspaceId);

        // Assert - should not call repository again
        expect(mockRepository.callCount, equals(0));
      });

      test('should load guests successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListGuestsResult =
            Result.success([testGuest1, testGuest2]);

        // Act
        await provider.loadGuests(testWorkspaceId);

        // Assert
        expect(provider.guests.length, equals(2));
        expect(provider.guests[0].id, equals('guest_1'));
        expect(provider.guests[0].name, equals('John Doe'));
        expect(provider.guests[1].id, equals('guest_2'));
        expect(provider.guests[1].name, equals('Jane Smith'));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
        expect(provider.recharge, isFalse);
      });

      test('should load empty guest list successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListGuestsResult = Result.success([]);

        // Act
        await provider.loadGuests(testWorkspaceId);

        // Assert
        expect(provider.guests, isEmpty);
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
        expect(provider.recharge, isFalse);
      });

      test('should handle error when loading guests fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListGuestsResult =
            Result.failure('Error al cargar invitados');

        // Act
        await provider.loadGuests(testWorkspaceId);

        // Assert
        expect(provider.guests, isEmpty);
        expect(provider.errorMessage, equals('Error al cargar invitados'));
        expect(provider.isLoading, isFalse);
      });

      test('should handle exception during loading', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListGuestsResult =
            Result.failure('Mock not configured');

        // Act
        await provider.loadGuests(testWorkspaceId);

        // Assert
        expect(provider.guests, isEmpty);
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });

      test('should set loading state during operation', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListGuestsResult = Result.success([testGuest1]);

        // Act
        final future = provider.loadGuests(testWorkspaceId);

        // Assert - loading should be true during operation
        expect(provider.isLoading, isTrue);

        await future;

        // Assert - loading should be false after operation
        expect(provider.isLoading, isFalse);
      });

      test('should update workspace ID when loading different workspace',
          () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId('workspace_1');
        mockRepository.mockListGuestsResult = Result.success([testGuest1]);
        await provider.loadGuests('workspace_1');

        // Reset mock for second workspace
        mockRepository.reset();
        mockRepository.mockListGuestsResult = Result.success([testGuest2]);

        // Act - load different workspace
        await provider.loadGuests('workspace_2');

        // Assert
        expect(provider.currentWorkspaceId, equals('workspace_2'));
        expect(mockRepository.callCount, equals(1));
      });
    });

    group('inviteGuest', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.inviteGuest(
            testWorkspaceId, 'new@example.com', 'viewer');

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.isLoading, isFalse);
      });

      test('should invite guest successfully and reload list', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);

        final newGuest = Guest(
          id: 'guest_3',
          name: 'New Guest',
          email: 'new@example.com',
          role: 'viewer',
        );

        mockRepository.mockInviteGuestResult = Result.success(newGuest);
        mockRepository.mockListGuestsResult = Result.success([newGuest]);

        // Act
        await provider.inviteGuest(testWorkspaceId, 'new@example.com', 'viewer');

        // Assert
        expect(provider.guests.length, equals(1));
        expect(provider.guests[0].id, equals('guest_3'));
        expect(provider.guests[0].email, equals('new@example.com'));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
        expect(mockRepository.callCount, equals(2)); // invite + loadGuests
      });

      test('should handle error when inviting guest fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockInviteGuestResult =
            Result.failure('Error al invitar');

        // Act
        await provider.inviteGuest(testWorkspaceId, 'new@example.com', 'viewer');

        // Assert
        expect(provider.errorMessage, equals('Error al invitar'));
        expect(provider.isLoading, isFalse);
        expect(mockRepository.callCount, equals(1)); // Only invite, no reload
      });

      test('should handle exception during invite', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockInviteGuestResult =
            Result.failure('Mock not configured');

        // Act
        await provider.inviteGuest(testWorkspaceId, 'new@example.com', 'viewer');

        // Assert
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });

      test('should set loading state during invite operation', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);

        final newGuest = Guest(
          id: 'guest_3',
          name: 'New Guest',
          email: 'new@example.com',
          role: 'viewer',
        );

        mockRepository.mockInviteGuestResult = Result.success(newGuest);
        mockRepository.mockListGuestsResult = Result.success([newGuest]);

        // Act
        final future =
            provider.inviteGuest(testWorkspaceId, 'new@example.com', 'viewer');

        // Assert - loading should be true during operation
        expect(provider.isLoading, isTrue);

        await future;

        // Assert - loading should be false after operation
        expect(provider.isLoading, isFalse);
      });
    });

    group('updateGuestRole', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.updateGuestRole(testWorkspaceId, 'guest_1', 'editor');

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.isLoading, isFalse);
      });

      test('should update guest role successfully and reload list', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);

        // Load initial guests
        mockRepository.mockListGuestsResult = Result.success([testGuest1]);
        await provider.loadGuests(testWorkspaceId);

        // Reset and prepare for update
        mockRepository.reset();
        final updatedGuest = Guest(
          id: 'guest_1',
          name: 'John Doe',
          email: 'john.doe@example.com',
          role: 'editor',
        );

        mockRepository.mockUpdateGuestRoleResult = Result.success(updatedGuest);
        mockRepository.mockListGuestsResult = Result.success([updatedGuest]);

        // Act
        await provider.updateGuestRole(testWorkspaceId, 'guest_1', 'editor');

        // Assert
        expect(provider.guests.length, equals(1));
        expect(provider.guests[0].role, equals('editor'));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
        expect(mockRepository.callCount, equals(2)); // update + loadGuests
      });

      test('should handle error when updating guest role fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockUpdateGuestRoleResult =
            Result.failure('Error al actualizar');

        // Act
        await provider.updateGuestRole(testWorkspaceId, 'guest_1', 'editor');

        // Assert
        expect(provider.errorMessage, equals('Error al actualizar'));
        expect(provider.isLoading, isFalse);
        expect(mockRepository.callCount, equals(1)); // Only update, no reload
      });

      test('should handle exception during update', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockUpdateGuestRoleResult =
            Result.failure('Mock not configured');

        // Act
        await provider.updateGuestRole(testWorkspaceId, 'guest_1', 'editor');

        // Assert
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });

      test('should set loading state during update operation', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);

        final updatedGuest = Guest(
          id: 'guest_1',
          name: 'John Doe',
          email: 'john.doe@example.com',
          role: 'editor',
        );

        mockRepository.mockUpdateGuestRoleResult = Result.success(updatedGuest);
        mockRepository.mockListGuestsResult = Result.success([updatedGuest]);

        // Act
        final future =
            provider.updateGuestRole(testWorkspaceId, 'guest_1', 'editor');

        // Assert - loading should be true during operation
        expect(provider.isLoading, isTrue);

        await future;

        // Assert - loading should be false after operation
        expect(provider.isLoading, isFalse);
      });
    });

    group('deleteGuest', () {
      test('should fail when user is not authenticated', () async {
        // Act
        await provider.deleteGuest(testWorkspaceId, 'guest_1');

        // Assert
        expect(provider.errorMessage, contains('no autenticado'));
        expect(provider.isLoading, isFalse);
      });

      test('should delete guest successfully and reload list', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);

        // Load initial guests
        mockRepository.mockListGuestsResult =
            Result.success([testGuest1, testGuest2]);
        await provider.loadGuests(testWorkspaceId);

        // Reset and prepare for delete
        mockRepository.reset();
        mockRepository.mockDeleteGuestResult = Result.success(true);
        mockRepository.mockListGuestsResult = Result.success([testGuest2]);

        // Act
        await provider.deleteGuest(testWorkspaceId, 'guest_1');

        // Assert
        expect(provider.guests.length, equals(1));
        expect(provider.guests[0].id, equals('guest_2'));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
        expect(mockRepository.callCount, equals(2)); // delete + loadGuests
      });

      test('should handle error when deleting guest fails', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockDeleteGuestResult =
            Result.failure('Error al eliminar');

        // Act
        await provider.deleteGuest(testWorkspaceId, 'guest_1');

        // Assert
        expect(provider.errorMessage, equals('Error al eliminar'));
        expect(provider.isLoading, isFalse);
        expect(mockRepository.callCount, equals(1)); // Only delete, no reload
      });

      test('should handle exception during delete', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockDeleteGuestResult =
            Result.failure('Mock not configured');

        // Act
        await provider.deleteGuest(testWorkspaceId, 'guest_1');

        // Assert
        expect(provider.errorMessage, isNotNull);
        expect(provider.isLoading, isFalse);
      });

      test('should set loading state during delete operation', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);

        mockRepository.mockDeleteGuestResult = Result.success(true);
        mockRepository.mockListGuestsResult = Result.success([]);

        // Act
        final future = provider.deleteGuest(testWorkspaceId, 'guest_1');

        // Assert - loading should be true during operation
        expect(provider.isLoading, isTrue);

        await future;

        // Assert - loading should be false after operation
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
        mockRepository.mockListGuestsResult = Result.success([testGuest1]);
        await provider.loadGuests(testWorkspaceId);

        expect(provider.recharge, isFalse);

        // Act - set same workspace ID again
        provider.setWorkspaceId(testWorkspaceId);

        // Assert - should not trigger reload
        expect(provider.recharge, isFalse);
      });

      test('should trigger reload when setting different workspace ID',
          () async {
        // Arrange
        provider.setWorkspaceId('workspace_1');
        mockAuthProvider.setMockUser(testUser, testToken);
        mockRepository.mockListGuestsResult = Result.success([testGuest1]);
        await provider.loadGuests('workspace_1');

        expect(provider.recharge, isFalse);

        // Act - set different workspace ID
        provider.setWorkspaceId('workspace_2');

        // Assert - should trigger reload
        expect(provider.recharge, isTrue);
        expect(provider.currentWorkspaceId, equals('workspace_2'));
      });

      test('should force reload', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, testToken);
        provider.setWorkspaceId(testWorkspaceId);
        mockRepository.mockListGuestsResult = Result.success([testGuest1]);
        await provider.loadGuests(testWorkspaceId);

        // Reset mock
        mockRepository.reset();
        mockRepository.mockListGuestsResult = Result.success([testGuest1]);

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

        // Act
        provider.clean();

        // Assert
        expect(provider.guests, isEmpty);
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
      });

      test('should clean error message', () async {
        // Arrange
        await provider.loadGuests(testWorkspaceId); // This will set an error

        // Act
        provider.cleanError();

        // Assert
        expect(provider.errorMessage, isNull);
      });

      test('should not clean error if no error exists', () {
        // Arrange
        expect(provider.errorMessage, isNull);

        // Act
        provider.cleanError();

        // Assert
        expect(provider.errorMessage, isNull);
      });
    });
  });
}
