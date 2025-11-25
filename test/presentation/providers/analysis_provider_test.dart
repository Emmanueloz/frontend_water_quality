import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/average_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/param_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/correlation.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/param_correlation.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/param_prediction.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/prediction.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/analysis_repo.dart';
import 'package:frontend_water_quality/presentation/providers/analysis_provider.dart';
import '../../mocks/mocks.dart';

class MockAnalysisRepository implements AnalysisRepo {
  Result<String>? mockCreateAveragesResult;
  Result<List<Average>>? mockGetAveragesResult;
  Result<String>? mockCreateAveragesPeriodResult;
  Result<List<AveragePeriod>>? mockGetAveragesPeriodResult;
  Result<String>? mockCreatePredictionResult;
  Result<List<PredictionSensor>>? mockGetPredictionsResult;
  Result<String>? mockCreateCorrelationResult;
  Result<List<Correlation>>? mockGetCorrelationsResult;
  Result<String>? mockDeleteResult;
  
  int callCount = 0;

  void reset() {
    mockCreateAveragesResult = null;
    mockGetAveragesResult = null;
    mockCreateAveragesPeriodResult = null;
    mockGetAveragesPeriodResult = null;
    mockCreatePredictionResult = null;
    mockGetPredictionsResult = null;
    mockCreateCorrelationResult = null;
    mockGetCorrelationsResult = null;
    mockDeleteResult = null;
    callCount = 0;
  }

  @override
  Future<Result<String>> createAverages(
      String workspaceId, String meterId, String token, Parameters param) async {
    callCount++;
    return mockCreateAveragesResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<List<Average>>> getAverages(
      String workspaceId, String meterId, String token) async {
    callCount++;
    return mockGetAveragesResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<String>> createAveragesPeriod(
      String workspaceId, String meterId, String token, ParamPeriod param) async {
    callCount++;
    return mockCreateAveragesPeriodResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<List<AveragePeriod>>> getAveragesPeriod(
      String workspaceId, String meterId, String token) async {
    callCount++;
    return mockGetAveragesPeriodResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<String>> createPrediction(
      String workspaceId, String meterId, String token, ParamPrediction param) async {
    callCount++;
    return mockCreatePredictionResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<List<PredictionSensor>>> getPredictions(
      String workspaceId, String meterId, String token) async {
    callCount++;
    return mockGetPredictionsResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<String>> createCorrelation(
      String workspaceId, String meterId, String token, ParamCorrelation param) async {
    callCount++;
    return mockCreateCorrelationResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<List<Correlation>>> getCorrelations(
      String workspaceId, String meterId, String token) async {
    callCount++;
    return mockGetCorrelationsResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<String>> delete(String id, String token) async {
    callCount++;
    return mockDeleteResult ?? Result.failure('Mock not configured');
  }
}

void main() {
  group('AnalysisProvider Tests', () {
    late MockAnalysisRepository mockRepository;
    late MockAuthProvider mockAuthProvider;
    late AnalysisProvider provider;

    setUp(() {
      mockRepository = MockAnalysisRepository();
      mockAuthProvider = MockAuthProvider();
      provider = AnalysisProvider(mockRepository, mockAuthProvider);
    });

    tearDown(() {
      mockRepository.reset();
    });

    group('createAverages', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        final param = Parameters(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        // Act
        final result = await provider.createAverages('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should create averages successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final param = Parameters(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        mockRepository.mockCreateAveragesResult = Result.success('analysis_1');

        // Act
        final result = await provider.createAverages('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('analysis_1'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final param = Parameters(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        mockRepository.mockCreateAveragesResult = Result.failure('Server error');

        // Act
        final result = await provider.createAverages('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Server error'));
      });

      test('should handle exception during creation', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final param = Parameters(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        // Act
        final result = await provider.createAverages('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });

    group('createAveragesPeriod', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        final param = ParamPeriod(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        // Act
        final result = await provider.createAveragesPeriod('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should create averages period successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final param = ParamPeriod(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        mockRepository.mockCreateAveragesPeriodResult = Result.success('analysis_2');

        // Act
        final result = await provider.createAveragesPeriod('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('analysis_2'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final param = ParamPeriod(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        mockRepository.mockCreateAveragesPeriodResult = Result.failure('Invalid parameters');

        // Act
        final result = await provider.createAveragesPeriod('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Invalid parameters'));
      });
    });

    group('createPrediction', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        final param = ParamPrediction(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        // Act
        final result = await provider.createPrediction('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should create prediction successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final param = ParamPrediction(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        mockRepository.mockCreatePredictionResult = Result.success('analysis_3');

        // Act
        final result = await provider.createPrediction('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('analysis_3'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final param = ParamPrediction(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        mockRepository.mockCreatePredictionResult = Result.failure('Insufficient data');

        // Act
        final result = await provider.createPrediction('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Insufficient data'));
      });
    });

    group('createCorrelation', () {
      test('should fail when user is not authenticated', () async {
        // Arrange
        final param = ParamCorrelation(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        // Act
        final result = await provider.createCorrelation('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should create correlation successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final param = ParamCorrelation(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        mockRepository.mockCreateCorrelationResult = Result.success('analysis_4');

        // Act
        final result = await provider.createCorrelation('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('analysis_4'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final param = ParamCorrelation(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );
        
        mockRepository.mockCreateCorrelationResult = Result.failure('Analysis failed');

        // Act
        final result = await provider.createCorrelation('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Analysis failed'));
      });
    });

    group('getAverage', () {
      test('should fail when user is not authenticated', () async {
        // Act
        final result = await provider.getAverage('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should get averages successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final testAverages = <Average>[];
        mockRepository.mockGetAveragesResult = Result.success(testAverages);

        // Act
        final result = await provider.getAverage('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals(testAverages));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        mockRepository.mockGetAveragesResult = Result.failure('Not found');

        // Act
        final result = await provider.getAverage('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Not found'));
      });
    });

    group('getAveragePeriod', () {
      test('should fail when user is not authenticated', () async {
        // Act
        final result = await provider.getAveragePeriod('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should get average period successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final testAveragePeriods = <AveragePeriod>[];
        mockRepository.mockGetAveragesPeriodResult = Result.success(testAveragePeriods);

        // Act
        final result = await provider.getAveragePeriod('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals(testAveragePeriods));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        mockRepository.mockGetAveragesPeriodResult = Result.failure('Access denied');

        // Act
        final result = await provider.getAveragePeriod('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Access denied'));
      });
    });

    group('getPredictions', () {
      test('should fail when user is not authenticated', () async {
        // Act
        final result = await provider.getPredictions('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should get predictions successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final testPredictions = <PredictionSensor>[];
        mockRepository.mockGetPredictionsResult = Result.success(testPredictions);

        // Act
        final result = await provider.getPredictions('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals(testPredictions));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        mockRepository.mockGetPredictionsResult = Result.failure('Server error');

        // Act
        final result = await provider.getPredictions('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Server error'));
      });
    });

    group('getCorrelations', () {
      test('should fail when user is not authenticated', () async {
        // Act
        final result = await provider.getCorrelations('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should get correlations successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        final testCorrelations = <Correlation>[];
        mockRepository.mockGetCorrelationsResult = Result.success(testCorrelations);

        // Act
        final result = await provider.getCorrelations('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals(testCorrelations));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        mockRepository.mockGetCorrelationsResult = Result.failure('Invalid request');

        // Act
        final result = await provider.getCorrelations('workspace_1', 'meter_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Invalid request'));
      });
    });

    group('delete', () {
      test('should fail when user is not authenticated', () async {
        // Act
        final result = await provider.delete('analysis_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
        expect(mockRepository.callCount, equals(0));
      });

      test('should delete analysis successfully when authenticated', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        mockRepository.mockDeleteResult = Result.success('Deleted successfully');

        // Act
        final result = await provider.delete('analysis_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Deleted successfully'));
        expect(mockRepository.callCount, equals(1));
      });

      test('should handle repository failure', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);
        
        mockRepository.mockDeleteResult = Result.failure('Analysis not found');

        // Act
        final result = await provider.delete('analysis_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Analysis not found'));
      });

      test('should handle exception during deletion', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);

        // Act
        final result = await provider.delete('analysis_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });

    group('authentication state management', () {
      test('should handle null auth provider', () async {
        // Arrange
        provider.setAuthProvider(null);
        final param = Parameters(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        // Act
        final result = await provider.createAverages('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
      });

      test('should handle null token', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          null,
        );
        provider.setAuthProvider(mockAuthProvider);
        final param = Parameters(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        // Act
        final result = await provider.createAverages('workspace_1', 'meter_1', param);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('not authenticated'));
      });

      test('should update auth provider', () async {
        // Arrange
        final newAuthProvider = MockAuthProvider();
        newAuthProvider.setMockUser(
          User(uid: 'user_2', email: 'new@example.com'),
          'new_token',
        );

        // Act
        provider.setAuthProvider(newAuthProvider);
        
        mockRepository.mockDeleteResult = Result.success('Deleted');
        final result = await provider.delete('analysis_1');

        // Assert
        expect(result.isSuccess, isTrue);
      });
    });

    group('different analysis types', () {
      test('should create different analysis types with proper parameters', () async {
        // Arrange
        mockAuthProvider.setMockUser(
          User(uid: 'user_1', email: 'test@example.com'),
          'test_token',
        );
        provider.setAuthProvider(mockAuthProvider);

        mockRepository.mockCreateAveragesResult = Result.success('avg_1');
        mockRepository.mockCreateAveragesPeriodResult = Result.success('avg_period_1');
        mockRepository.mockCreatePredictionResult = Result.success('pred_1');
        mockRepository.mockCreateCorrelationResult = Result.success('corr_1');

        // Act & Assert - Averages
        final avgResult = await provider.createAverages(
          'workspace_1',
          'meter_1',
          Parameters(startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 31)),
        );
        expect(avgResult.isSuccess, isTrue);

        // Act & Assert - Averages Period
        final avgPeriodResult = await provider.createAveragesPeriod(
          'workspace_1',
          'meter_1',
          ParamPeriod(startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 31)),
        );
        expect(avgPeriodResult.isSuccess, isTrue);

        // Act & Assert - Prediction
        final predResult = await provider.createPrediction(
          'workspace_1',
          'meter_1',
          ParamPrediction(startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 31)),
        );
        expect(predResult.isSuccess, isTrue);

        // Act & Assert - Correlation
        final corrResult = await provider.createCorrelation(
          'workspace_1',
          'meter_1',
          ParamCorrelation(startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 31)),
        );
        expect(corrResult.isSuccess, isTrue);

        // Verify all calls were made
        expect(mockRepository.callCount, equals(4));
      });
    });
  });
}
