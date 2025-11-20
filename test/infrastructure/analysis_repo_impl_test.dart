import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/analysis_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/param_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/param_correlation.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/param_prediction.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/average_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/correlation.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/prediction.dart';
import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import '../utils/mock_dio.dart';

void main() {
  group('AnalysisRepositoryImpl Tests', () {
    late MockDio mockDio;
    late AnalysisRepoImpl repository;

    // Test data
    final testParameters = Parameters(
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
      sensor: SensorType.temperature,
    );

    final testParamPeriod = ParamPeriod(
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
      sensor: SensorType.temperature,
      periodType: 'daily',
    );

    final testParamCorrelation = ParamCorrelation(
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
      periodType: 'daily',
      method: 'pearson',
      sensors: [SensorType.temperature, SensorType.ph],
    );

    final testParamPrediction = ParamPrediction(
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
      sensor: SensorType.temperature,
      periodType: 'daily',
      ahead: 7,
    );

    setUp(() {
      mockDio = MockDio();
      repository = AnalysisRepoImpl(mockDio);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('createAverages', () {
      test('should return success when API returns 201', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Analysis created'},
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createAverages(
          'workspace_1',
          'meter_1',
          'test_token',
          testParameters,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Averages created successfully'));
      });

      test('should return success when API returns 200', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Analysis created'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createAverages(
          'workspace_1',
          'meter_1',
          'test_token',
          testParameters,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Averages created successfully'));
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
        final result = await repository.createAverages(
          'workspace_1',
          'meter_1',
          'test_token',
          testParameters,
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.createAverages(
          'workspace_1',
          'meter_1',
          'test_token',
          testParameters,
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.createAverages(
          'workspace_1',
          'meter_1',
          'test_token',
          testParameters,
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.createAverages(
          'workspace_1',
          'meter_1',
          'test_token',
          testParameters,
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createAverages(
          'workspace_1',
          'meter_1',
          'test_token',
          testParameters,
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });
    });

    group('createAveragesPeriod', () {
      test('should return success when API returns 201', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Analysis created'},
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createAveragesPeriod(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPeriod,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Averages created successfully'));
      });

      test('should return success when API returns 200', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Analysis created'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createAveragesPeriod(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPeriod,
        );

        // Assert
        expect(result.isSuccess, isTrue);
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
        final result = await repository.createAveragesPeriod(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPeriod,
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.createAveragesPeriod(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPeriod,
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });
    });

    group('createCorrelation', () {
      test('should return success when API returns 201', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Correlation created'},
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createCorrelation(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamCorrelation,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Averages created successfully'));
      });

      test('should return success when API returns 200', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Correlation created'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createCorrelation(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamCorrelation,
        );

        // Assert
        expect(result.isSuccess, isTrue);
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
        final result = await repository.createCorrelation(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamCorrelation,
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.createCorrelation(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamCorrelation,
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.createCorrelation(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamCorrelation,
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.createCorrelation(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamCorrelation,
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createCorrelation(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamCorrelation,
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });
    });

    group('createPrediction', () {
      test('should return success when API returns 201', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Prediction created'},
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createPrediction(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPrediction,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Averages created successfully'));
      });

      test('should return success when API returns 200', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Prediction created'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createPrediction(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPrediction,
        );

        // Assert
        expect(result.isSuccess, isTrue);
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
        final result = await repository.createPrediction(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPrediction,
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.createPrediction(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPrediction,
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.createPrediction(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPrediction,
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.createPrediction(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPrediction,
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });

      test('should handle connection failure error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.createPrediction(
          'workspace_1',
          'meter_1',
          'test_token',
          testParamPrediction,
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });
    });

    group('getAverages', () {
      test('should return success when API returns 200 with averages data',
          () async {
        // Arrange
        final responseData = {
          'result': {
            'analysis_1': {
              'id': 'analysis_1',
              'workspace_id': 'workspace_1',
              'meter_id': 'meter_1',
              'parameters': {
                'start_date': '2024-01-01T00:00:00.000Z',
                'end_date': '2024-01-31T00:00:00.000Z',
              },
              'data': {
                'all': {'average': 25.5, 'count': 100},
                'TEMPERATURE': {'average': 25.5, 'count': 100},
              }
            }
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getAverages(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Average>>());
        expect(result.value!.length, equals(1));
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
        final result = await repository.getAverages(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.getAverages(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.getAverages(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getAverages(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });
    });

    group('getAveragesPeriod', () {
      test('should return success when API returns 200 with period data',
          () async {
        // Arrange
        final responseData = {
          'result': {
            'analysis_1': {
              "created_at": "2025-09-21 23:16:00.348126",
              "data": {
                "period": {
                  "end_date": "2025-09-19T23:59:00",
                  "start_date": "2025-04-01T00:00:00"
                },
                "period_type": "months",
                "results": {
                  "conductivity": {
                    "labels": ["2025-08-31T00:00:00", "2025-09-30T00:00:00"],
                    "values": [1357.8187320507552, 1485.800051170245]
                  },
                  "ph": {
                    "labels": ["2025-08-31T00:00:00", "2025-09-30T00:00:00"],
                    "values": [5.089485242838196, 5.038926807535724]
                  },
                  "tds": {
                    "labels": ["2025-08-31T00:00:00", "2025-09-30T00:00:00"],
                    "values": [231.29920410989263, 245.5463665926781]
                  },
                  "temperature": {
                    "labels": ["2025-08-31T00:00:00", "2025-09-30T00:00:00"],
                    "values": [17.471170807714017, 17.403541591870752]
                  },
                  "turbidity": {
                    "labels": ["2025-08-31T00:00:00", "2025-09-30T00:00:00"],
                    "values": [22.85534779101629, 24.742207417322415]
                  }
                }
              },
              "error": "",
              "meter_id": "-OVnW46EjvIYWdpO8zPz",
              "parameters": {
                "end_date": "2025-09-19 23:59:00",
                "period_type": "months",
                "start_date": "2025-04-01 00:00:00"
              },
              "status": "saved",
              "type": "average_period",
              "updated_at": "2025-09-21 23:16:05.124989",
              "workspace_id": "-OV6KJon4LkGwCw8pNvh"
            }
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getAveragesPeriod(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<AveragePeriod>>());
        expect(result.value!.length, equals(1));
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
        final result = await repository.getAveragesPeriod(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.getAveragesPeriod(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.getAveragesPeriod(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });
    });

    group('getCorrelations', () {
      test('should return success when API returns 200 with correlation data',
          () async {
        // Arrange
        final responseData = {
          'result': {
            'analysis_1': {
              'id': 'analysis_1',
              'workspace_id': 'workspace_1',
              'meter_id': 'meter_1',
              'parameters': {
                'start_date': '2024-01-01T00:00:00.000Z',
                'end_date': '2024-01-31T00:00:00.000Z',
                'period_type': 'daily',
                'method': 'pearson',
              },
              'data': {
                'matrix': [
                  [1.0, 0.8],
                  [0.8, 1.0]
                ],
                'sensors': ['TEMPERATURE', 'PH']
              }
            }
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getCorrelations(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Correlation>>());
        expect(result.value!.length, equals(1));
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
        final result = await repository.getCorrelations(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.getCorrelations(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.getCorrelations(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });

      test('should handle connection failure error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getCorrelations(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });
    });

    group('getPredictions', () {
      test('should return success when API returns 200 with prediction data',
          () async {
        // Arrange
        final responseData = {
          'result': {
            'analysis_1': {
              'id': 'analysis_1',
              'workspace_id': 'workspace_1',
              'meter_id': 'meter_1',
              'parameters': {
                'start_date': '2024-01-01T00:00:00.000Z',
                'end_date': '2024-01-31T00:00:00.000Z',
                'period_type': 'daily',
                'ahead': 7,
              },
              'data': {
                'TEMPERATURE': [
                  {'date': '2024-02-01', 'predicted': 26.0}
                ]
              }
            }
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getPredictions(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<PredictionSensor>>());
        expect(result.value!.length, equals(1));
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
        final result = await repository.getPredictions(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.getPredictions(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.getPredictions(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.getPredictions(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getPredictions(
          'workspace_1',
          'meter_1',
          'test_token',
        );

        // Assert
        expect(result.isSuccess, isFalse);
      });
    });

    group('delete', () {
      test('should return success when API returns 200', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'message': 'Analysis deleted'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.delete('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, equals('Analysis deleted successfully'));
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
        final result = await repository.delete('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.delete('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.delete('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
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
        final result = await repository.delete('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.delete('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
      });

      test('should handle connection failure error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.delete('analysis_1', 'test_token');

        // Assert
        expect(result.isSuccess, isFalse);
      });
    });
  });
}
