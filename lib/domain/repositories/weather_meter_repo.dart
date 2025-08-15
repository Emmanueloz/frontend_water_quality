import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/weather_meter.dart';

abstract class WeatherMeterRepo {
  Future<Result<WeatherMeter>> getWeather(String userToken, String workspaceId, String meterId);
}