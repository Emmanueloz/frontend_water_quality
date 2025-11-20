import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/meter_records_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/meter_records_response.dart';
import '../utils/mock_dio.dart';

void main() {
  group('MeterRecordsRepoImpl Tests', () {
    late MockDio mockDio;
    late MeterRecordsRepoImpl repository;

    // Test data
    final testRecordsData = {
      'records': {
        'color': [
          {
            'id': 'color_1',
            'value': {'r': 100, 'g': 150, 'b': 200},
            'datetime': '2024-01-01T10:00:00Z'
          },
          {
            'id': 'color_2',
            'value': {'r': 110, 'g': 160, 'b': 210},
            'datetime': '2024-01-01T11:00:00Z'
          }
        ],
        'conductivity': [
          {
            'id': 'cond_1',
            'value': 500.5,
            'datetime': '2024-01-01T10:00:00Z'
          },
          {
            'id': 'cond_2',
            'value': 510.2,
            'datetime': '2024-01-01T11:00:00Z'
          }
        ],
        'ph': [
          {'id': 'ph_1', 'value': 7.2, 'datetime': '2024-01-01T10:00:00Z'},
          {'id': 'ph_2', 'value': 7.3, 'datetime': '2024-01-01T11:00:00Z'}
        ],
        'temperature': [
          {
            'id': 'temp_1',
            'value': 25.5,
            'datetime': '2024-01-01T10:00:00Z'
          },
          {
            'id': 'temp_2',
            'value': 26.0,
            'datetime': '2024-01-01T11:00:00Z'
          }
        ],
        'tds': [
          {'id': 'tds_1', 'value': 300.0, 'datetime': '2024-01-01T10:00:00Z'},
          {'id': 'tds_2', 'value': 305.0, 'datetime': '2024-01-01T11:00:00Z'}
        ],
        'turbidity': [
          {
            'id': 'turb_1',
            'value': 2.5,
            'datetime': '2024-01-01T10:00:00Z'
          },
          {
            'id': 'turb_2',
            'value': 2.7,
            'datetime': '2024-01-01T11:00:00Z'
          }
        ]
      }
    };

    final testEmptyRecordsData = {
      'records': {
        'color': [],
        'conductivity': [],
        'ph': [],
        'temperature': [],
        'tds': [],
        'turbidity': []
      }
    };

    setUp(() {
      mockDio = MockDio();
      repository = MeterRecordsRepoImpl(mockDio);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('fetchMeterRecords - Success Scenarios', () {
      test('should return success when API returns 200 with records',
          () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: testRecordsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<MeterRecordsResponse>());
        expect(result.value!.colorRecords.length, equals(2));
        expect(result.value!.conductivityRecords.length, equals(2));
        expect(result.value!.phRecords.length, equals(2));
        expect(result.value!.temperatureRecords.length, equals(2));
        expect(result.value!.tdsRecords.length, equals(2));
        expect(result.value!.turbidityRecords.length, equals(2));
      });

      test('should return success with date range parameters', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: testRecordsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31);

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
          startDate: startDate,
          endDate: endDate,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<MeterRecordsResponse>());
        expect(result.value!.phRecords.length, equals(2));
      });

      test('should return success with pagination parameter', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: testRecordsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
          lastId: 'last_record_id',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<MeterRecordsResponse>());
      });

      test('should parse color records with RGB values correctly', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: testRecordsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        final colorRecord = result.value!.colorRecords.first;
        expect(colorRecord.value.r, equals(100));
        expect(colorRecord.value.g, equals(150));
        expect(colorRecord.value.b, equals(200));
        expect(colorRecord.datetime, equals('2024-01-01T10:00:00Z'));
      });

      test('should parse numeric sensor records correctly', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: testRecordsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.phRecords.first.value, equals(7.2));
        expect(result.value!.temperatureRecords.first.value, equals(25.5));
        expect(result.value!.conductivityRecords.first.value, equals(500.5));
        expect(result.value!.tdsRecords.first.value, equals(300.0));
        expect(result.value!.turbidityRecords.first.value, equals(2.5));
      });
    });

    group('fetchMeterRecords - Empty Data Scenarios', () {
      test('should return success when records arrays are empty', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: testEmptyRecordsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.colorRecords.length, equals(0));
        expect(result.value!.conductivityRecords.length, equals(0));
      });

      test('should return failure when records field is null', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {'records': null},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('No records found'));
      });

      test('should return failure when records field is missing', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('No records found'));
      });
    });

    group('fetchMeterRecords - HTTP Error Codes', () {
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
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
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
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
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
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
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
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
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
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should return failure when status code is not 200', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: testRecordsData,
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: código 201'));
      });
    });

    group('fetchMeterRecords - Network Errors', () {
      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
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
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
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
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle send timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.sendTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });

    group('fetchMeterRecords - Pagination', () {
      test('should handle large dataset with pagination', () async {
        // Arrange - Create a large dataset
        final largeRecordsData = {
          'records': {
            'color': List.generate(
              100,
              (i) => {
                'id': 'color_$i',
                'value': {'r': 100 + i, 'g': 150 + i, 'b': 200 + i},
                'datetime': '2024-01-01T${i.toString().padLeft(2, '0')}:00:00Z'
              },
            ),
            'conductivity': List.generate(
              100,
              (i) => {
                'id': 'cond_$i',
                'value': 500.0 + i,
                'datetime': '2024-01-01T${i.toString().padLeft(2, '0')}:00:00Z'
              },
            ),
            'ph': List.generate(
              100,
              (i) => {
                'id': 'ph_$i',
                'value': 7.0 + (i * 0.01),
                'datetime': '2024-01-01T${i.toString().padLeft(2, '0')}:00:00Z'
              },
            ),
            'temperature': List.generate(
              100,
              (i) => {
                'id': 'temp_$i',
                'value': 25.0 + i * 0.1,
                'datetime': '2024-01-01T${i.toString().padLeft(2, '0')}:00:00Z'
              },
            ),
            'tds': List.generate(
              100,
              (i) => {
                'id': 'tds_$i',
                'value': 300.0 + i,
                'datetime': '2024-01-01T${i.toString().padLeft(2, '0')}:00:00Z'
              },
            ),
            'turbidity': List.generate(
              100,
              (i) => {
                'id': 'turb_$i',
                'value': 2.0 + i * 0.01,
                'datetime': '2024-01-01T${i.toString().padLeft(2, '0')}:00:00Z'
              },
            )
          }
        };

        mockDio.mockResponse = Response(
          data: largeRecordsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.colorRecords.length, equals(100));
        expect(result.value!.conductivityRecords.length, equals(100));
        expect(result.value!.phRecords.length, equals(100));
        expect(result.value!.temperatureRecords.length, equals(100));
        expect(result.value!.tdsRecords.length, equals(100));
        expect(result.value!.turbidityRecords.length, equals(100));
      });

      test('should handle pagination with lastId parameter', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: testRecordsData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
          lastId: 'record_50',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<MeterRecordsResponse>());
      });
    });

    group('fetchMeterRecords - Malformed Data', () {
      test('should handle malformed color value', () async {
        // Arrange
        final malformedData = {
          'records': {
            'color': [
              {
                'id': 'color_1',
                'value': {'r': 'invalid', 'g': 150, 'b': 200},
                'datetime': '2024-01-01T10:00:00Z'
              }
            ],
            'conductivity': [],
            'ph': [],
            'temperature': [],
            'tds': [],
            'turbidity': []
          }
        };

        mockDio.mockResponse = Response(
          data: malformedData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle missing sensor type in records', () async {
        // Arrange
        final incompleteData = {
          'records': {
            'color': [
              {
                'id': 'color_1',
                'value': {'r': 100, 'g': 150, 'b': 200},
                'datetime': '2024-01-01T10:00:00Z'
              }
            ],
            'conductivity': [
              {
                'id': 'cond_1',
                'value': 500.5,
                'datetime': '2024-01-01T10:00:00Z'
              }
            ],
            // Missing ph, temperature, tds, turbidity
          }
        };

        mockDio.mockResponse = Response(
          data: incompleteData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle invalid numeric value', () async {
        // Arrange
        final invalidNumericData = {
          'records': {
            'color': [
              {
                'id': 'color_1',
                'value': {'r': 100, 'g': 150, 'b': 200},
                'datetime': '2024-01-01T10:00:00Z'
              }
            ],
            'conductivity': [
              {
                'id': 'cond_1',
                'value': 'not_a_number',
                'datetime': '2024-01-01T10:00:00Z'
              }
            ],
            'ph': [],
            'temperature': [],
            'tds': [],
            'turbidity': []
          }
        };

        mockDio.mockResponse = Response(
          data: invalidNumericData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.fetchMeterRecords(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });
  });
}
