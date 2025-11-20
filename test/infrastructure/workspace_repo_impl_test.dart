import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/workspace_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/core/enums/type_workspace.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import '../utils/mock_dio.dart';

void main() {
  group('WorkspaceRepositoryImpl Tests', () {
    late MockDio mockDio;
    late WorkspaceRepoImpl repository;

    // Test data
    final testWorkspace = Workspace(
      id: 'workspace_1',
      name: 'Test Workspace',
      owner: 'user_1',
      type: TypeWorkspace.private,
    );

    setUp(() {
      mockDio = MockDio();
      repository = WorkspaceRepoImpl(mockDio);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('create', () {
      test('should return success when API returns 201', () async {
        // Arrange
        final responseData = {
          'message': 'Workspace created successfully',
          'detail': 'workspace_1',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.create('test_token', testWorkspace);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<BaseResponse>());
        expect(result.value!.message, equals('Workspace created successfully'));
      });

      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'message': 'Workspace created',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.create('test_token', testWorkspace);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<BaseResponse>());
      });

      test('should return failure when API returns 400', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.create('test_token', testWorkspace);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 400'));
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
        final result = await repository.create('test_token', testWorkspace);

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
        final result = await repository.create('test_token', testWorkspace);

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
        final result = await repository.create('test_token', testWorkspace);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.create('test_token', testWorkspace);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });

    group('getAll', () {
      test('should return success when API returns 200 with workspaces array',
          () async {
        // Arrange
        final responseData = {
          'data': [
            {
              'id': 'workspace_1',
              'name': 'Test Workspace',
              'owner': 'user_1',
              'type': 'private',
            },
            {
              'id': 'workspace_2',
              'name': 'Another Workspace',
              'owner': 'user_1',
              'type': 'public',
            }
          ]
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getAll('test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
        expect(result.value!.length, equals(2));
        expect(result.value![0].id, equals('workspace_1'));
        expect(result.value![0].name, equals('Test Workspace'));
        expect(result.value![1].id, equals('workspace_2'));
      });

      test('should return success when API returns 200 with empty array',
          () async {
        // Arrange
        final responseData = {'data': []};
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getAll('test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
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
        final result = await repository.getAll('test_token');

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
        final result = await repository.getAll('test_token');

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
        final result = await repository.getAll('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getAll('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });

    group('getById', () {
      test('should return success when API returns 200 with workspace object',
          () async {
        // Arrange
        final responseData = {
          'data': {
            'id': 'workspace_1',
            'name': 'Test Workspace',
            'owner': 'user_1',
            'type': 'private',
          }
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getById('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<Workspace>());
        expect(result.value!.id, equals('workspace_1'));
        expect(result.value!.name, equals('Test Workspace'));
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
        final result = await repository.getById('test_token', 'workspace_1');

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
        final result = await repository.getById('test_token', 'workspace_1');

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
        final result = await repository.getById('test_token', 'workspace_1');

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
        final result = await repository.getById('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getById('test_token', 'workspace_1');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });

    group('getShared', () {
      test('should return success when API returns 200 with workspaces array',
          () async {
        // Arrange
        final responseData = {
          'workspaces': [
            {
              'id': 'workspace_1',
              'name': 'Shared Workspace',
              'owner': 'user_2',
              'type': 'public',
            }
          ]
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getShared('test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
        expect(result.value!.length, equals(1));
        expect(result.value![0].id, equals('workspace_1'));
        expect(result.value![0].name, equals('Shared Workspace'));
      });

      test('should return success when API returns 200 with empty array',
          () async {
        // Arrange
        final responseData = {'workspaces': []};
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getShared('test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
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
        final result = await repository.getShared('test_token');

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
        final result = await repository.getShared('test_token');

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
        final result = await repository.getShared('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getShared('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });

    group('getFullAll', () {
      test('should return success when API returns 200 with workspaces array',
          () async {
        // Arrange
        final responseData = {
          'workspaces': [
            {
              'id': 'workspace_1',
              'name': 'Test Workspace',
              'owner': 'user_1',
              'type': 'private',
            },
            {
              'id': 'workspace_2',
              'name': 'Shared Workspace',
              'owner': 'user_2',
              'type': 'public',
            }
          ]
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getFullAll('test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
        expect(result.value!.length, equals(2));
        expect(result.value![0].id, equals('workspace_1'));
        expect(result.value![1].id, equals('workspace_2'));
      });

      test('should return success when API returns 200 with empty array',
          () async {
        // Arrange
        final responseData = {'workspaces': []};
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getFullAll('test_token');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<List<Workspace>>());
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
        final result = await repository.getFullAll('test_token');

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
        final result = await repository.getFullAll('test_token');

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
        final result = await repository.getFullAll('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getFullAll('test_token');

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });

    group('update', () {
      test('should return success when API returns 200', () async {
        // Arrange
        final responseData = {
          'message': 'Workspace updated successfully',
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('test_token', testWorkspace);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<BaseResponse>());
        expect(result.value!.message, equals('Workspace updated successfully'));
      });

      test('should return failure when API returns 400', () async {
        // Arrange
        mockDio.mockResponse = Response(
          data: {},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('test_token', testWorkspace);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: codigo 400'));
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
        final result = await repository.update('test_token', testWorkspace);

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
        final result = await repository.update('test_token', testWorkspace);

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
        final result = await repository.update('test_token', testWorkspace);

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
        final result = await repository.update('test_token', testWorkspace);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });

      test('should handle connection timeout error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.update('test_token', testWorkspace);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotEmpty);
      });
    });
  });
}
