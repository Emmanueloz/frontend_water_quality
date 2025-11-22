import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/meter_records_response.dart';
import 'package:frontend_water_quality/domain/models/record_models.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/meter_records_repo.dart';
import 'package:frontend_water_quality/infrastructure/meter_socket_service.dart';
import 'package:frontend_water_quality/presentation/providers/meter_record_provider.dart';
import 'package:frontend_water_quality/core/enums/roles.dart';
import '../../mocks/mocks.dart';

class MockMeterRecordsRepository implements MeterRecordsRepo {
  Result<MeterRecordsResponse>? mockFetchMeterRecordsResult;

  int callCount = 0;
  String? lastToken;
  String? lastWorkspaceId;
  String? lastMeterId;
  DateTime? lastStartDate;
  DateTime? lastEndDate;
  String? lastLastId;

  void reset() {
    mockFetchMeterRecordsResult = null;
    callCount = 0;
    lastToken = null;
    lastWorkspaceId = null;
    lastMeterId = null;
    lastStartDate = null;
    lastEndDate = null;
    lastLastId = null;
  }

  @override
  Future<Result<MeterRecordsResponse>> fetchMeterRecords(
    String userToken,
    String workspaceId,
    String meterId, {
    DateTime? startDate,
    DateTime? endDate,
    String? lastId,
  }) async {
    callCount++;
    lastToken = userToken;
    lastWorkspaceId = workspaceId;
    lastMeterId = meterId;
    lastStartDate = startDate;
    lastEndDate = endDate;
    lastLastId = lastId;
    return mockFetchMeterRecordsResult ?? Result.failure('Mock not configured');
  }
}

class MockMeterSocketService extends MeterSocketService {
  bool connectCalled = false;
  bool disconnectCalled = false;
  String? lastBaseUrl;
  String? lastToken;
  String? lastIdWorkspace;
  String? lastIdMeter;
  Function(dynamic)? lastOnData;

  void reset() {
    connectCalled = false;
    disconnectCalled = false;
    lastBaseUrl = null;
    lastToken = null;
    lastIdWorkspace = null;
    lastIdMeter = null;
    lastOnData = null;
  }

  @override
  Future<void> connect({
    required String baseUrl,
    required String token,
    required String idWorkspace,
    required String idMeter,
    required Function(dynamic) onData,
  }) async {
    connectCalled = true;
    lastBaseUrl = baseUrl;
    lastToken = token;
    lastIdWorkspace = idWorkspace;
    lastIdMeter = idMeter;
    lastOnData = onData;
  }

  @override
  void disconnect() {
    disconnectCalled = true;
  }
}

void main() {
  group('MeterRecordProvider Tests', () {
    late MockMeterRecordsRepository mockRepository;
    late MockMeterSocketService mockSocketService;
    late MockAuthProvider mockAuthProvider;
    late MeterRecordProvider provider;

    // Test data
    final testUser = User(
      uid: 'user_1',
      email: 'test@example.com',
      username: 'testuser',
      rol: AppRoles.admin,
    );

    final testRecordsResponse = MeterRecordsResponse(
      colorRecords: [
        Record<SRColorValue>(
          id: 'color_1',
          value: SRColorValue(r: 100, g: 150, b: 200),
          datetime: '2024-01-01T10:00:00Z',
        ),
      ],
      conductivityRecords: [
        Record<double>(
          id: 'cond_1',
          value: 500.5,
          datetime: '2024-01-01T10:00:00Z',
        ),
      ],
      phRecords: [
        Record<double>(
          id: 'ph_1',
          value: 7.2,
          datetime: '2024-01-01T10:00:00Z',
        ),
      ],
      temperatureRecords: [
        Record<double>(
          id: 'temp_1',
          value: 25.5,
          datetime: '2024-01-01T10:00:00Z',
        ),
      ],
      tdsRecords: [
        Record<double>(
          id: 'tds_1',
          value: 300.0,
          datetime: '2024-01-01T10:00:00Z',
        ),
      ],
      turbidityRecords: [
        Record<double>(
          id: 'turb_1',
          value: 2.5,
          datetime: '2024-01-01T10:00:00Z',
        ),
      ],
    );

    setUp(() {
      mockRepository = MockMeterRecordsRepository();
      mockSocketService = MockMeterSocketService();
      mockAuthProvider = MockAuthProvider();
      provider = MeterRecordProvider(
        mockSocketService,
        mockRepository,
        mockAuthProvider,
      );
    });

    tearDown(() {
      mockRepository.reset();
      mockSocketService.reset();
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        // Assert
        expect(provider.isLoading, isFalse);
        expect(provider.recordResponse, isNull);
        expect(provider.meterRecordsResponse, isNull);
        expect(provider.errorMessageSocket, isNull);
        expect(provider.errorMessageRecords, isNull);
        expect(provider.hasActiveFilters, isFalse);
        expect(provider.hasNextPage, isFalse);
        expect(provider.hasPreviousPage, isFalse);
      });
    });

    group('fetchMeterRecords', () {
      test('should not fetch when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        await provider.fetchMeterRecords('workspace_1', 'meter_1');

        // Assert
        expect(mockRepository.callCount, equals(0));
      });

      test('should fetch records successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);
        bool listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        // Act
        await provider.fetchMeterRecords('workspace_1', 'meter_1');

        // Assert
        expect(provider.meterRecordsResponse, isNotNull);
        expect(provider.meterRecordsResponse!.phRecords.length, equals(1));
        expect(provider.errorMessageRecords, isNull);
        expect(provider.isLoading, isFalse);
        expect(listenerCalled, isTrue);
        expect(mockRepository.callCount, equals(1));
      });

      test('should set loading state during fetch', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);
        bool loadingWasTrue = false;

        provider.addListener(() {
          if (provider.isLoading) {
            loadingWasTrue = true;
          }
        });

        // Act
        await provider.fetchMeterRecords('workspace_1', 'meter_1');

        // Assert
        expect(loadingWasTrue, isTrue);
        expect(provider.isLoading, isFalse);
      });

      test('should handle fetch failure with error message', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.failure('Failed to fetch records');

        // Act
        await provider.fetchMeterRecords('workspace_1', 'meter_1');

        // Assert
        expect(provider.meterRecordsResponse, isNull);
        expect(provider.errorMessageRecords, equals('Failed to fetch records'));
        expect(provider.isLoading, isFalse);
      });

      test('should fetch records with date range filtering', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31);

        // Act
        await provider.fetchMeterRecords(
          'workspace_1',
          'meter_1',
          startDate: startDate,
          endDate: endDate,
        );

        // Assert
        expect(provider.meterRecordsResponse, isNotNull);
        expect(mockRepository.lastStartDate, equals(startDate));
        expect(mockRepository.lastEndDate, equals(endDate));
        expect(provider.currentStartDate, equals(startDate));
        expect(provider.currentEndDate, equals(endDate));
        expect(provider.hasActiveFilters, isTrue);
      });

      test('should fetch records with pagination', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        // Act
        await provider.fetchMeterRecords(
          'workspace_1',
          'meter_1',
          lastId: 'last_record_id',
        );

        // Assert
        expect(provider.meterRecordsResponse, isNotNull);
        expect(mockRepository.lastLastId, equals('last_record_id'));
      });

      test('should clear records when workspace changes', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        // First fetch
        await provider.fetchMeterRecords('workspace_1', 'meter_1');
        expect(provider.meterRecordsResponse, isNotNull);

        // Act - Change workspace
        await provider.fetchMeterRecords('workspace_2', 'meter_1');

        // Assert
        expect(mockRepository.callCount, equals(2));
        expect(provider.meterRecordsResponse, isNotNull);
      });

      test('should clear records when meter changes', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        // First fetch
        await provider.fetchMeterRecords('workspace_1', 'meter_1');
        expect(provider.meterRecordsResponse, isNotNull);

        // Act - Change meter
        await provider.fetchMeterRecords('workspace_1', 'meter_2');

        // Assert
        expect(mockRepository.callCount, equals(2));
        expect(provider.meterRecordsResponse, isNotNull);
      });

      test('should notify listeners on successful fetch', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.fetchMeterRecords('workspace_1', 'meter_1');

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should notify listeners on fetch failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.failure('Failed to fetch records');
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.fetchMeterRecords('workspace_1', 'meter_1');

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('applyDateFilters', () {
      test('should apply date filters and fetch records', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        // Initial fetch
        await provider.fetchMeterRecords('workspace_1', 'meter_1');

        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31);

        // Act
        await provider.applyDateFilters(startDate, endDate);

        // Assert
        expect(provider.currentStartDate, equals(startDate));
        expect(provider.currentEndDate, equals(endDate));
        expect(provider.hasActiveFilters, isTrue);
        expect(mockRepository.callCount, equals(2));
      });

      test('should not apply filters when workspace is not set', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31);

        // Act
        await provider.applyDateFilters(startDate, endDate);

        // Assert
        expect(mockRepository.callCount, equals(0));
      });

      test('should clear pagination history when applying filters', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        // Initial fetch with pagination
        await provider.fetchMeterRecords('workspace_1', 'meter_1',
            lastId: 'page_1');

        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31);

        // Act
        await provider.applyDateFilters(startDate, endDate);

        // Assert
        expect(provider.hasPreviousPage, isFalse);
      });
    });

    group('clearFilters', () {
      test('should clear date filters and fetch records', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        // Fetch with filters
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31);
        await provider.fetchMeterRecords('workspace_1', 'meter_1',
            startDate: startDate, endDate: endDate);
        expect(provider.hasActiveFilters, isTrue);

        // Act
        await provider.clearFilters();

        // Assert
        expect(provider.currentStartDate, isNull);
        expect(provider.currentEndDate, isNull);
        expect(provider.hasActiveFilters, isFalse);
        expect(mockRepository.callCount, equals(2));
      });

      test('should clear pagination history when clearing filters', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        // Fetch with pagination
        await provider.fetchMeterRecords('workspace_1', 'meter_1',
            lastId: 'page_1');

        // Act
        await provider.clearFilters();

        // Assert
        expect(provider.hasPreviousPage, isFalse);
      });
    });

    group('refreshMeterRecords', () {
      test('should refresh records with current filters', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31);
        await provider.fetchMeterRecords('workspace_1', 'meter_1',
            startDate: startDate, endDate: endDate);

        // Act
        await provider.refreshMeterRecords();

        // Assert
        expect(mockRepository.callCount, equals(2));
        expect(mockRepository.lastStartDate, equals(startDate));
        expect(mockRepository.lastEndDate, equals(endDate));
      });

      test('should not refresh when workspace is not set', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');

        // Act
        await provider.refreshMeterRecords();

        // Assert
        expect(mockRepository.callCount, equals(0));
      });
    });

    group('Pagination', () {
      test('should navigate to next page', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        // Initial fetch
        await provider.fetchMeterRecords('workspace_1', 'meter_1');
        expect(provider.hasNextPage, isTrue);

        // Act
        await provider.goToNextPage();

        // Assert
        expect(mockRepository.callCount, equals(2));
        expect(mockRepository.lastLastId, isNotNull);
      });

      test('should not navigate to next page when no next page exists',
          () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        final emptyResponse = MeterRecordsResponse(
          colorRecords: [],
          conductivityRecords: [],
          phRecords: [],
          temperatureRecords: [],
          tdsRecords: [],
          turbidityRecords: [],
        );
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(emptyResponse);

        await provider.fetchMeterRecords('workspace_1', 'meter_1');
        expect(provider.hasNextPage, isFalse);

        // Act
        await provider.goToNextPage();

        // Assert
        expect(mockRepository.callCount, equals(1));
      });

      test('should navigate to previous page', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        // Fetch first page
        await provider.fetchMeterRecords('workspace_1', 'meter_1');

        // Fetch second page
        await provider.goToNextPage();
        expect(provider.hasPreviousPage, isTrue);

        // Act
        await provider.goToPreviousPage();

        // Assert
        expect(mockRepository.callCount, equals(3));
      });

      test('should not navigate to previous page when no previous page exists',
          () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        await provider.fetchMeterRecords('workspace_1', 'meter_1');
        expect(provider.hasPreviousPage, isFalse);

        // Act
        await provider.goToPreviousPage();

        // Assert
        expect(mockRepository.callCount, equals(1));
      });
    });

    group('subscribeToMeter', () {
      test('should subscribe to meter successfully', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');

        // Act
        provider.subscribeToMeter(
          baseUrl: 'http://localhost:3000',
          idWorkspace: 'workspace_1',
          idMeter: 'meter_1',
        );

        // Wait for async operations
        await Future.delayed(Duration(milliseconds: 10));

        // Assert
        expect(mockSocketService.connectCalled, isTrue);
        expect(mockSocketService.lastBaseUrl, equals('http://localhost:3000'));
        expect(mockSocketService.lastToken, equals('test_token'));
        expect(mockSocketService.lastIdWorkspace, equals('workspace_1'));
        expect(mockSocketService.lastIdMeter, equals('meter_1'));
      });

      test('should not subscribe when user is not authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);

        // Act
        provider.subscribeToMeter(
          baseUrl: 'http://localhost:3000',
          idWorkspace: 'workspace_1',
          idMeter: 'meter_1',
        );

        // Wait for async operations
        await Future.delayed(Duration(milliseconds: 10));

        // Assert
        expect(mockSocketService.connectCalled, isFalse);
        expect(provider.errorMessageSocket, equals('User not authenticated'));
      });

      test('should notify listeners on subscription error', () async {
        // Arrange
        mockAuthProvider.setMockUser(null, null);
        int notifyCount = 0;

        provider.addListener(() {
          notifyCount++;
        });

        // Act
        provider.subscribeToMeter(
          baseUrl: 'http://localhost:3000',
          idWorkspace: 'workspace_1',
          idMeter: 'meter_1',
        );

        // Wait for async operations
        await Future.delayed(Duration(milliseconds: 10));

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('unsubscribe', () {
      test('should unsubscribe from meter', () {
        // Act
        provider.unsubscribe();

        // Assert
        expect(mockSocketService.disconnectCalled, isTrue);
      });
    });

    group('clean', () {
      test('should clean all state', () async {
        // Arrange
        mockAuthProvider.setMockUser(testUser, 'test_token');
        mockRepository.mockFetchMeterRecordsResult =
            Result.success(testRecordsResponse);

        await provider.fetchMeterRecords('workspace_1', 'meter_1');
        expect(provider.meterRecordsResponse, isNotNull);

        // Act
        provider.clean();

        // Assert
        expect(provider.recordResponse, isNull);
        expect(provider.meterRecordsResponse, isNull);
        expect(provider.errorMessageSocket, isNull);
        expect(provider.errorMessageRecords, isNull);
        expect(provider.hasActiveFilters, isFalse);
        expect(provider.hasNextPage, isFalse);
        expect(provider.hasPreviousPage, isFalse);
      });
    });
  });
}
