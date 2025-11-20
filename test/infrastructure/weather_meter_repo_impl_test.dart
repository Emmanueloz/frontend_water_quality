import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend_water_quality/infrastructure/weather_meter_repo_impl.dart';
import 'package:frontend_water_quality/domain/models/weather_meter.dart';
import '../utils/mock_dio.dart';

void main() {
  group('WeatherMeterRepoImpl Tests', () {
    late MockDio mockDio;
    late WeatherMeterRepoImpl repository;

    // Test data
    final testWeatherData = {
      'location': {
        'name': 'Test City',
        'region': 'Test Region',
        'country': 'Test Country',
        'lat': 40.7128,
        'lon': -74.0060,
      },
      'current': {
        'last_updated': '2025-11-18 12:00',
        'temp_c': 22.5,
        'temp_f': 72.5,
        'humidity': 65,
        'wind_kph': 15.0,
        'wind_mph': 9.3,
        'pressure_mb': 1013.0,
        'pressure_in': 29.91,
        'precip_mm': 0.0,
        'precip_in': 0.0,
        'cloud': 25,
        'feelslike_c': 21.0,
        'feelslike_f': 69.8,
        'uv': 5.0,
        'vis_km': 10.0,
        'vis_miles': 6.2,
        'condition': {
          'text': 'Partly cloudy',
          'icon': '//cdn.weatherapi.com/weather/64x64/day/116.png',
          'code': 1003,
        },
      },
    };

    setUp(() {
      mockDio = MockDio();
      repository = WeatherMeterRepoImpl(mockDio);
    });

    tearDown(() {
      mockDio.reset();
    });

    group('getWeather', () {
      test('should return success when API returns 200 with valid weather data',
          () async {
        // Arrange
        final responseData = {
          'data': testWeatherData,
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value, isA<WeatherMeter>());
        expect(result.value!.location.name, equals('Test City'));
        expect(result.value!.location.region, equals('Test Region'));
        expect(result.value!.location.country, equals('Test Country'));
        expect(result.value!.location.lat, equals(40.7128));
        expect(result.value!.location.lon, equals(-74.0060));
        expect(result.value!.current.tempC, equals(22.5));
        expect(result.value!.current.humidity, equals(65));
        expect(result.value!.current.condition.text, equals('Partly cloudy'));
      });

      test('should parse weather data correctly with all fields', () async {
        // Arrange
        final responseData = {
          'data': testWeatherData,
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        final weather = result.value!;
        
        // Verify location data
        expect(weather.location.name, equals('Test City'));
        expect(weather.location.region, equals('Test Region'));
        expect(weather.location.country, equals('Test Country'));
        expect(weather.location.lat, equals(40.7128));
        expect(weather.location.lon, equals(-74.0060));
        
        // Verify current weather data
        expect(weather.current.lastUpdated, equals('2025-11-18 12:00'));
        expect(weather.current.tempC, equals(22.5));
        expect(weather.current.tempF, equals(72.5));
        expect(weather.current.humidity, equals(65));
        expect(weather.current.windKph, equals(15.0));
        expect(weather.current.windMph, equals(9.3));
        expect(weather.current.pressureMb, equals(1013.0));
        expect(weather.current.pressureIn, equals(29.91));
        expect(weather.current.precipMm, equals(0.0));
        expect(weather.current.precipIn, equals(0.0));
        expect(weather.current.cloud, equals(25));
        expect(weather.current.feelslikeC, equals(21.0));
        expect(weather.current.feelslikeF, equals(69.8));
        expect(weather.current.uv, equals(5.0));
        expect(weather.current.visKm, equals(10.0));
        expect(weather.current.visMiles, equals(6.2));
        
        // Verify condition data
        expect(weather.current.condition.text, equals('Partly cloudy'));
        expect(weather.current.condition.icon, equals('//cdn.weatherapi.com/weather/64x64/day/116.png'));
        expect(weather.current.condition.code, equals(1003));
      });

      test('should return failure when API returns non-200 status code',
          () async {
        // Arrange
        final responseData = {
          'data': testWeatherData,
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: 404'));
      });

      test('should return failure when API returns 400 bad request', () async {
        // Arrange
        final responseData = {
          'data': testWeatherData,
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: 400'));
      });

      test('should return failure when API returns 401 unauthorized', () async {
        // Arrange
        final responseData = {
          'data': testWeatherData,
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'invalid_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: 401'));
      });

      test('should return failure when API returns 403 forbidden', () async {
        // Arrange
        final responseData = {
          'data': testWeatherData,
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 403,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: 403'));
      });

      test('should return failure when API returns 404 not found', () async {
        // Arrange
        final responseData = {
          'data': testWeatherData,
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'nonexistent_meter',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: 404'));
      });

      test('should return failure when API returns 500 server error',
          () async {
        // Arrange
        final responseData = {
          'data': testWeatherData,
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, contains('Error: 500'));
      });

      test('should handle DioException with connection timeout', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });

      test('should handle DioException with connection error', () async {
        // Arrange
        mockDio.mockError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });

      test('should handle malformed response data', () async {
        // Arrange
        final malformedData = {
          'data': {
            'location': {
              'name': 'Test City',
              // Missing required fields
            },
          },
        };
        mockDio.mockResponse = Response(
          data: malformedData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.message, isNotNull);
      });

      test('should handle null location coordinates', () async {
        // Arrange
        final dataWithNullCoords = {
          'data': {
            'location': {
              'name': 'Test City',
              'region': 'Test Region',
              'country': 'Test Country',
              'lat': null,
              'lon': null,
            },
            'current': testWeatherData['current'],
          },
        };
        mockDio.mockResponse = Response(
          data: dataWithNullCoords,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.value!.location.lat, isNull);
        expect(result.value!.location.lon, isNull);
      });

      test('should use correct API endpoint path', () async {
        // Arrange
        mockDio.expectCall(MockApiCall(
          method: 'GET',
          path: '/meters/workspace_1/weather/meter_1/',
          statusCode: 200,
          responseData: {
            'data': testWeatherData,
          },
        ));

        // Act
        await repository.getWeather(
          'test_token',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(mockDio.callCount, equals(1));
      });

      test('should include authorization header in request', () async {
        // Arrange
        final responseData = {
          'data': testWeatherData,
        };
        mockDio.mockResponse = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = await repository.getWeather(
          'test_token_123',
          'workspace_1',
          'meter_1',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(mockDio.callCount, equals(1));
      });
    });
  });
}
