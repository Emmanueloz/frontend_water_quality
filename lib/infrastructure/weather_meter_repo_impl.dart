import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/weather_meter.dart';
import 'package:frontend_water_quality/domain/repositories/weather_meter_repo.dart';

class WeatherMeterRepoImpl implements WeatherMeterRepo {
  final Dio _dio;

  WeatherMeterRepoImpl(this._dio);

  @override
  Future<Result<WeatherMeter>> getWeather(String userToken, String workspaceId, String meterId) async {
    try {
      final response = await _dio.get('/meters/$workspaceId/weather/$meterId/', 
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );
      final WeatherMeter weatherMeter = WeatherMeter.fromJson(response.data);
      if (response.statusCode == 200) {
        return Result.success(weatherMeter);
      } else {
        return Result.failure('Error: ${response.statusCode}');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}