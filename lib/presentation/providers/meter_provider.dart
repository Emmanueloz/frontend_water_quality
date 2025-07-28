
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/meter_records_response.dart';
import 'package:frontend_water_quality/domain/repositories/meter_records_repo.dart';
import 'package:frontend_water_quality/infrastructure/meter_socket_service.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/domain/models/record_models.dart';

class MeterProvider with ChangeNotifier {
  AuthProvider? _authProvider;

  final MeterSocketService _socketService;
  final MeterRecordsRepo _meterRecordsRepo;
  RecordResponse? recordResponse;
  MeterRecordsResponse? meterRecordsResponse;
  bool isLoading = false;
  MeterProvider( this._socketService, this._meterRecordsRepo,  this._authProvider);
  String? errorMessage;


    void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  void clean() {
    errorMessage = null;
    recordResponse = null;
    meterRecordsResponse = null;
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
          recordResponse = RecordResponse.fromJson(data);
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

  Future<void> fetchMeterRecords(String idWorkspace, String idMeter) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }

    isLoading = true;
    meterRecordsResponse = null;
    notifyListeners();

    try {
      final result = await _meterRecordsRepo.fetchMeterRecords(
        _authProvider!.token!,
        idWorkspace,
        idMeter,
      );
      print("Result: ${result.value}");
      if (!result.isSuccess) {
        errorMessage = result.message;
        notifyListeners();
        return;
      }

      meterRecordsResponse = result.value;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void unsubscribe() {
    _socketService.disconnect();
    clean();
  }
} 