import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/domain/models/weather_meter.dart';
import 'package:frontend_water_quality/domain/repositories/weather_meter_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class WeatherMeterProvider with ChangeNotifier{
  AuthProvider? _authProvider;
  final WeatherMeterRepo _weatherMeterRepo;
  WeatherMeterProvider(this._weatherMeterRepo, this._authProvider);

  WeatherMeter? weatherMeter;
  bool isLoading = false;
  String? errorMessage;


  void clean(){
    weatherMeter = null;
    isLoading = false;
    errorMessage = null;
  }

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  Future<void> fetchWeather(String idWorkspace, String idMeter) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }

    isLoading = true;
    weatherMeter = null;
    notifyListeners();

    try{
      final result = await _weatherMeterRepo.getWeather(_authProvider!.token!, idWorkspace, idMeter);
      if (!result.isSuccess) {
        errorMessage = result.message;
        return;
      }

      weatherMeter = result.value;
      errorMessage = null;
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
}

