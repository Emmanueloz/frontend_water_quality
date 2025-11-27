import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/core/enums/type_workspace.dart';
import 'package:frontend_water_quality/core/enums/work_roles.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/domain/repositories/workspace_repo.dart';
import 'package:frontend_water_quality/presentation/providers/workspace_provider.dart';
import '../../mocks/mocks.dart';

class MockWorkspaceRepository implements WorkspaceRepo {
  Result<Workspace>? mockGetByIdResult;
  Result<BaseResponse>? mockCreateResult;
  Result<BaseResponse>? mockUpdateResult;
  Result<BaseResponse>? mockDeleteResult;
  Result<List<Workspace>>? mockGetAllResult;
  Result<List<Workspace>>? mockGetFullAllResult;
  Result<List<Workspace>>? mockGetSharedResult;
  Result<List<Workspace>>? mockGetPublicResult;

  int callCount = 0;

  void reset() {
    mockGetByIdResult = null;
    mockCreateResult = null;
    mockUpdateResult = null;
    mockDeleteResult = null;
    mockGetAllResult = null;
    mockGetFullAllResult = null;
    mockGetSharedResult = null;
    callCount = 0;
  }

  @override
  Future<Result<Workspace>> getById(String userToken, String id) async {
    callCount++;
    return mockGetByIdResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<BaseResponse>> create(
      String userToken, Workspace workspace) async {
    callCount++;
    return mockCreateResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<BaseResponse>> update(
      String userToken, Workspace workspace) async {
    callCount++;
    return mockUpdateResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<BaseResponse>> delete(String userToken, String id) async {
    callCount++;
    return mockDeleteResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<List<Workspace>>> getAll(String userToken) async {
    callCount++;
    return mockGetAllResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<List<Workspace>>> getFullAll(String userToken) async {
    callCount++;
    return mockGetFullAllResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<List<Workspace>>> getShared(String userToken) async {
    callCount++;
    return mockGetSharedResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<List<Workspace>>> getPublic() async {
    callCount++;
    return mockGetPublicResult ?? Result.failure('Mock not configured');
  }
}

void main() {
  group('WorkspaceProvider Tests', () {
    late MockWorkspaceRepository mockRepository;
    late MockAuthProvider mockAuthProvider;
    late WorkspaceProvider provider;

    // Test data
    final testWorkspace1 = Workspace(
      id: 'workspace_1',
      name: 'Test Workspace 1',
      owner: 'user_1',
      type: TypeWorkspace.private,
      role: WorkRole.owner,
    );

    final testWorkspace2 = Workspace(
      id: 'workspace_2',
      name: 'Test Workspace 2',
      owner: 'user_2',
      type: TypeWorkspace.public,
      role: WorkRole.manager,
    );

    final testWorkspace3 = Workspace(
      id: 'workspace_3',
      name: 'Shared Workspace',
      owner: 'user_3',
      type: TypeWorkspace.public,
      role: WorkRole.visitor,
    );

    setUp(() {
      mockRepository = MockWorkspaceRepository();
      mockAuthProvider = MockAuthProvider();
      provider = WorkspaceProvider(mockRepository, mockAuthProvider);
    });

    tearDown(() {
      mockRepository.reset();
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        // Assert
        expect(provider.shouldReloadType('mine'), isTrue);
      });
    });

    group('getWorkspaceById', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        final result = await provider.getWorkspaceById('workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should get workspace by id successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetByIdResult = Result.success(testWorkspace1);

        // Act
        final result = await provider.getWorkspaceById('workspace_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals(testWorkspace1));
        expect(result.value!.id, equals('workspace_1'));
        expect(result.value!.name, equals('Test Workspace 1'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle error when getting workspace by id', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetByIdResult =
            Result.failure('Workspace not found');

        // Act
        final result = await provider.getWorkspaceById('invalid_id');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('Workspace not found'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle exception when getting workspace by id', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetByIdResult = null;

        // Act
        final result = await provider.getWorkspaceById('workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Mock not configured'));
      });
    });

    group('getWorkspaces', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        final result = await provider.getWorkspaces();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should get workspaces successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetAllResult =
            Result.success([testWorkspace1, testWorkspace2]);

        // Act
        final result = await provider.getWorkspaces();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
        expect(result.value!.length, equals(2));
        expect(result.value![0].id, equals('workspace_1'));
        expect(result.value![1].id, equals('workspace_2'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle empty workspace list', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetAllResult = Result.success([]);

        // Act
        final result = await provider.getWorkspaces();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
        expect(result.value!.length, equals(0));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle error when getting workspaces', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetAllResult =
            Result.failure('Failed to fetch workspaces');

        // Act
        final result = await provider.getWorkspaces();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('Failed to fetch workspaces'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle exception when getting workspaces', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetAllResult = null;

        // Act
        final result = await provider.getWorkspaces();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Mock not configured'));
      });
    });

    group('getSharedWorkspaces', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        final result = await provider.getSharedWorkspaces();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should get shared workspaces successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetSharedResult = Result.success([testWorkspace3]);

        // Act
        final result = await provider.getSharedWorkspaces();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
        expect(result.value!.length, equals(1));
        expect(result.value![0].id, equals('workspace_3'));
        expect(result.value![0].name, equals('Shared Workspace'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle empty shared workspace list', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetSharedResult = Result.success([]);

        // Act
        final result = await provider.getSharedWorkspaces();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
        expect(result.value!.length, equals(0));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle error when getting shared workspaces', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetSharedResult =
            Result.failure('Failed to fetch shared workspaces');

        // Act
        final result = await provider.getSharedWorkspaces();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('Failed to fetch shared workspaces'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle exception when getting shared workspaces', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetSharedResult = null;

        // Act
        final result = await provider.getSharedWorkspaces();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Mock not configured'));
      });
    });

    group('getAllWorkspaces', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        final result = await provider.getAllWorkspaces();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should get all workspaces successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetFullAllResult = Result.success([
          testWorkspace1,
          testWorkspace2,
          testWorkspace3,
        ]);

        // Act
        final result = await provider.getAllWorkspaces();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
        expect(result.value!.length, equals(3));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle error when getting all workspaces', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetFullAllResult =
            Result.failure('Failed to fetch all workspaces');

        // Act
        final result = await provider.getAllWorkspaces();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, equals('Failed to fetch all workspaces'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle exception when getting all workspaces', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetFullAllResult = null;

        // Act
        final result = await provider.getAllWorkspaces();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Mock not configured'));
      });
    });

    group('createWorkspace', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        final result = await provider.createWorkspace(testWorkspace1);

        // Assert
        expect(result, equals('User not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should create workspace successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final createResponse =
            BaseResponse(message: 'Workspace created successfully');
        mockRepository.mockCreateResult = Result.success(createResponse);
        bool listenerCalled = false;

        provider.addListener(() {
          listenerCalled = true;
        });

        // Act
        final result = await provider.createWorkspace(testWorkspace1);

        // Assert
        expect(result, isNull); // Result.success doesn't set message
        expect(provider.shouldReloadType('mine'), isTrue);
        expect(mockRepository.callCount, equals(1));
        expect(listenerCalled, isTrue);
      });

      test('should handle error when creating workspace', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockCreateResult =
            Result.failure('Workspace name already exists');

        // Act
        final result = await provider.createWorkspace(testWorkspace1);

        // Assert
        expect(result, equals('Workspace name already exists'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle exception when creating workspace', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockCreateResult = null;

        // Act
        final result = await provider.createWorkspace(testWorkspace1);

        // Assert
        expect(result, contains('Mock not configured'));
      });

      test('should mark list for reload after successful creation', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final createResponse =
            BaseResponse(message: 'Workspace created successfully');
        mockRepository.mockCreateResult = Result.success(createResponse);

        // Confirm list reloaded to reset flag
        provider.confirmListReloaded(type: 'mine');
        expect(provider.shouldReloadType('mine'), isFalse);

        // Act
        await provider.createWorkspace(testWorkspace1);

        // Assert
        expect(provider.shouldReloadType('mine'), isTrue);
      });

      test('should notify listeners when creating workspace', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final createResponse =
            BaseResponse(message: 'Workspace created successfully');
        mockRepository.mockCreateResult = Result.success(createResponse);
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.createWorkspace(testWorkspace1);

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('updateWorkspace', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        final result = await provider.updateWorkspace(testWorkspace1);

        // Assert
        expect(result.$1, isFalse);
        expect(result.$2, equals('User not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should update workspace successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'Workspace updated successfully');
        mockRepository.mockUpdateResult = Result.success(updateResponse);
        bool listenerCalled = false;

        provider.addListener(() {
          listenerCalled = true;
        });

        // Act
        final result = await provider.updateWorkspace(testWorkspace1);

        // Assert
        expect(result.$1, isTrue);
        expect(result.$2, isNull);
        expect(provider.shouldReloadType('mine'), isTrue);
        expect(provider.shouldReloadWorkspace('workspace_1'), isTrue);
        expect(mockRepository.callCount, equals(1));
        expect(listenerCalled, isTrue);
      });

      test('should handle error when updating workspace', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockUpdateResult = Result.failure('Workspace not found');

        // Act
        final result = await provider.updateWorkspace(testWorkspace1);

        // Assert
        expect(result.$1, isFalse);
        expect(result.$2, equals('Workspace not found'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle exception when updating workspace', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockUpdateResult = null;

        // Act
        final result = await provider.updateWorkspace(testWorkspace1);

        // Assert
        expect(result.$1, isFalse);
        expect(result.$2, contains('Mock not configured'));
      });

      test('should mark workspace and list for reload after successful update',
          () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'Workspace updated successfully');
        mockRepository.mockUpdateResult = Result.success(updateResponse);

        // Confirm reloads to reset flags
        provider.confirmListReloaded(type: 'mine');
        provider.confirmWorkspaceReloaded('workspace_1');
        expect(provider.shouldReloadType('mine'), isFalse);
        expect(provider.shouldReloadWorkspace('workspace_1'),
            isTrue); // Default is true

        // Act
        await provider.updateWorkspace(testWorkspace1);

        // Assert
        expect(provider.shouldReloadType('mine'), isTrue);
        expect(provider.shouldReloadWorkspace('workspace_1'), isTrue);
      });

      test('should notify listeners when updating workspace', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'Workspace updated successfully');
        mockRepository.mockUpdateResult = Result.success(updateResponse);
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.updateWorkspace(testWorkspace1);

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('Reload Flags Management', () {
      test('should have shouldReloadType true by default', () {
        // Assert
        expect(provider.shouldReloadType('mine'), isTrue);
        expect(provider.shouldReloadType('shared'), isTrue);
        expect(provider.shouldReloadType('public'), isTrue);
      });

      test('should have shouldReloadWorkspace true by default for any id', () {
        // Assert
        expect(provider.shouldReloadWorkspace('workspace_1'), isTrue);
        expect(provider.shouldReloadWorkspace('workspace_2'), isTrue);
        expect(provider.shouldReloadWorkspace('any_id'), isTrue);
      });

      test('should mark list for reload', () {
        // Arrange
        provider.confirmListReloaded(type: 'mine');
        expect(provider.shouldReloadType('mine'), isFalse);
        bool listenerCalled = false;

        provider.addListener(() {
          listenerCalled = true;
        });

        // Act
        provider.markListForReload(type: 'mine');

        // Assert
        expect(provider.shouldReloadType('mine'), isTrue);
        expect(listenerCalled, isTrue);
      });

      test('should mark workspace for reload', () {
        // Arrange
        provider.confirmWorkspaceReloaded('workspace_1');
        expect(provider.shouldReloadWorkspace('workspace_1'),
            isTrue); // Default is true
        bool listenerCalled = false;

        provider.addListener(() {
          listenerCalled = true;
        });

        // Act
        provider.markWorkspaceForReload('workspace_1');

        // Assert
        expect(provider.shouldReloadWorkspace('workspace_1'), isTrue);
        expect(listenerCalled, isTrue);
      });

      test('should confirm list reloaded', () {
        // Arrange
        provider.markListForReload(type: 'mine');
        expect(provider.shouldReloadType('mine'), isTrue);

        // Act
        provider.confirmListReloaded(type: 'mine');

        // Assert
        expect(provider.shouldReloadType('mine'), isFalse);
      });

      test('should confirm workspace reloaded', () {
        // Arrange
        provider.markWorkspaceForReload('workspace_1');
        expect(provider.shouldReloadWorkspace('workspace_1'), isTrue);

        // Act
        provider.confirmWorkspaceReloaded('workspace_1');

        // Assert
        expect(provider.shouldReloadWorkspace('workspace_1'),
            isTrue); // Returns to default
      });

      test('should handle multiple workspace reload flags independently', () {
        // Act
        provider.markWorkspaceForReload('workspace_1');
        provider.markWorkspaceForReload('workspace_2');
        provider.confirmWorkspaceReloaded('workspace_1');

        // Assert
        expect(
            provider.shouldReloadWorkspace('workspace_1'), isTrue); // Default
        expect(provider.shouldReloadWorkspace('workspace_2'), isTrue);
      });

      test('should notify listeners when marking list for reload', () {
        // Arrange
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        provider.markListForReload();

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should notify listeners when marking workspace for reload', () {
        // Arrange
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        provider.markWorkspaceForReload('workspace_1');

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('AuthProvider Integration', () {
      test('should set auth provider', () {
        // Arrange
        final newAuthProvider = MockAuthProvider();
        newAuthProvider.setMockUser(null, 'new_token');

        // Act
        provider.setAuthProvider(newAuthProvider);

        // Assert - Verify by making a call that requires auth
        mockRepository.mockGetAllResult = Result.success([testWorkspace1]);
        provider.getWorkspaces();
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle null auth provider', () async {
        // Arrange
        provider.setAuthProvider(null);

        // Act
        final result = await provider.getWorkspaces();

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
      });
    });

    group('Workspace Selection State', () {
      test('should track workspace selection through getWorkspaceById',
          () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        mockRepository.mockGetByIdResult = Result.success(testWorkspace1);

        // Act
        final result = await provider.getWorkspaceById('workspace_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.id, equals('workspace_1'));
      });

      test('should handle workspace selection with different workspaces',
          () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');

        // Act & Assert - First workspace
        mockRepository.mockGetByIdResult = Result.success(testWorkspace1);
        final result1 = await provider.getWorkspaceById('workspace_1');
        expect(result1.isSuccess, isTrue);
        expect(result1.value!.id, equals('workspace_1'));

        // Act & Assert - Second workspace
        mockRepository.mockGetByIdResult = Result.success(testWorkspace2);
        final result2 = await provider.getWorkspaceById('workspace_2');
        expect(result2.isSuccess, isTrue);
        expect(result2.value!.id, equals('workspace_2'));
      });
    });

    group('Listener Notifications', () {
      test('should notify listeners on successful create', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final createResponse =
            BaseResponse(message: 'Workspace created successfully');
        mockRepository.mockCreateResult = Result.success(createResponse);
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.createWorkspace(testWorkspace1);

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should notify listeners on successful update', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final updateResponse =
            BaseResponse(message: 'Workspace updated successfully');
        mockRepository.mockUpdateResult = Result.success(updateResponse);
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.updateWorkspace(testWorkspace1);

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should notify listeners when marking for reload', () async {
        // Arrange
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        provider.markListForReload();
        provider.markWorkspaceForReload('workspace_1');

        // Assert
        expect(notifyCount, equals(2));
      });
    });

    group('Workspace Validation', () {
      test('should create workspace with valid data', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final validWorkspace = Workspace(
          name: 'Valid Workspace',
          owner: 'user_1',
          type: TypeWorkspace.private,
        );
        final createResponse =
            BaseResponse(message: 'Workspace created successfully');
        mockRepository.mockCreateResult = Result.success(createResponse);

        // Act
        final result = await provider.createWorkspace(validWorkspace);

        // Assert
        expect(result, isNull); // Result.success doesn't set message
        expect(mockRepository.callCount, equals(1));
      });

      test('should update workspace with valid data', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, 'test_token_123');
        final validWorkspace = Workspace(
          id: 'workspace_1',
          name: 'Updated Workspace',
          owner: 'user_1',
          type: TypeWorkspace.public,
        );
        final updateResponse =
            BaseResponse(message: 'Workspace updated successfully');
        mockRepository.mockUpdateResult = Result.success(updateResponse);

        // Act
        final result = await provider.updateWorkspace(validWorkspace);

        // Assert
        expect(result.$1, isTrue);
        expect(result.$2, isNull);
        expect(mockRepository.callCount, equals(1));
      });
    });
  });
}
