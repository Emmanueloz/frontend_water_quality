import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/meter_records_response.dart';
import 'package:frontend_water_quality/domain/repositories/meter_records_repo.dart';
import 'package:frontend_water_quality/infrastructure/meter_socket_service.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/domain/models/record_models.dart';

class MeterRecordProvider with ChangeNotifier {
  AuthProvider? _authProvider;

  final MeterSocketService _socketService;
  final MeterRecordsRepo _meterRecordsRepo;
  RecordResponse? recordResponse;
  MeterRecordsResponse? meterRecordsResponse;
  bool isLoading = false;
  String? errorMessage;

  String? _currentWorkspaceId;
  String? _currentMeterId;
  bool _recordsLoaded = false;

  MeterRecordProvider(
      this._socketService, this._meterRecordsRepo, this._authProvider);

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  void clean() {
    recordResponse = null;
    // Limpiar registros también cuando se hace clean general
    cleanRecords();
  }

  // Método para limpiar solo datos en tiempo real (no registros)
  void cleanRealtimeData() {
    errorMessage = null;
    recordResponse = null;
  }

  // Método para limpiar registros cuando cambia el medidor o workspace
  void cleanRecords() {
    meterRecordsResponse = null;
    _currentWorkspaceId = null;
    _currentMeterId = null;
    _recordsLoaded = false;
    errorMessage = null;
  }

  void subscribeToMeter({
    required String baseUrl,
    required String idWorkspace,
    required String idMeter,
  }) async {
    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }
    try {
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
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> fetchMeterRecords(String idWorkspace, String idMeter) async {
    // Verificar si ya tenemos los datos para este medidor
    if (_recordsLoaded &&
        _currentWorkspaceId == idWorkspace &&
        _currentMeterId == idMeter) {
      return; // Ya tenemos los datos, no recargar
    }

    if (_authProvider == null || _authProvider!.token == null) {
      errorMessage = "User not authenticated";
      notifyListeners();
      return;
    }

    // Si cambió el medidor o workspace, limpiar datos anteriores
    if (_currentWorkspaceId != idWorkspace || _currentMeterId != idMeter) {
      cleanRecords();
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await _meterRecordsRepo.fetchMeterRecords(
        _authProvider!.token!,
        idWorkspace,
        idMeter,
      );
      if (!result.isSuccess) {
        errorMessage = result.message;
        return;
      }

      meterRecordsResponse = result.value;
      _currentWorkspaceId = idWorkspace;
      _currentMeterId = idMeter;
      _recordsLoaded = true;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Método para recarga manual
  Future<void> refreshMeterRecords() async {
    if (_currentWorkspaceId != null && _currentMeterId != null) {
      _recordsLoaded = false; // Forzar recarga
      await fetchMeterRecords(_currentWorkspaceId!, _currentMeterId!);
    }
  }

  void unsubscribe() {
    _socketService.disconnect();
  }
}
