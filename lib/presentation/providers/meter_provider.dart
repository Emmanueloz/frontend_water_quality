import 'package:flutter/material.dart';
import 'package:frontend_water_quality/infrastructure/meter_socket_service.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/domain/models/record_models.dart';

class MeterProvider with ChangeNotifier {
  AuthProvider? _authProvider;

  final MeterSocketService _socketService = MeterSocketService();
  dynamic meterData;
  RecordResponse? recordResponse;
  
  MeterProvider(this._authProvider);
  String? errorMessage;


    void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  void clean() {
    meterData = null;
    errorMessage = null;
  }
  void subscribeToMeter ( {
    required String baseUrl,
    required String idWorkspace,
    required String idMeter,
  }) async{
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }
    try{
      await _socketService.connect(
      baseUrl: baseUrl,
      token: _authProvider!.token!,
      idWorkspace: idWorkspace,
      idMeter: idMeter,
      onData: (data) {
        try {
          print("Received data: $data");
          recordResponse = RecordResponse.fromJson(data);
          meterData = data;
          errorMessage = null;
        } catch (e) {
          errorMessage = 'Error parsing data: ';
        }
        notifyListeners();
      },
    );
    }catch(e){
      errorMessage = e.toString();
    }
  }

  void unsubscribe() {
    _socketService.disconnect();
  }
} 