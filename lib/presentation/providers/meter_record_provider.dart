// lib/presentation/providers/meter_record_provider.dart
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
  String? errorMessageSocket;
  String? errorMessageRecords;

  String? _currentWorkspaceId;
  String? _currentMeterId;
  DateTime? _currentStartDate;
  DateTime? _currentEndDate;

  String? _currentLastId;
  final List<String> _indexHistory = []; // Historial de IDs usados

  MeterRecordProvider(
      this._socketService, this._meterRecordsRepo, this._authProvider);

  void setAuthProvider(AuthProvider? provider) => _authProvider = provider;

  bool get hasActiveFilters =>
      _currentStartDate != null || _currentEndDate != null;
  bool get hasNextPage => _currentLastId != null;
  bool get hasPreviousPage => _indexHistory.isNotEmpty;
  DateTime? get currentStartDate => _currentStartDate;
  DateTime? get currentEndDate => _currentEndDate;

  void clean() {
    recordResponse = null;
    errorMessageSocket = null;
    errorMessageRecords = null;
    meterRecordsResponse = null;
    _currentWorkspaceId = null;
    _currentMeterId = null;
    _currentStartDate = null;
    _currentEndDate = null;
    _currentLastId = null;
    _indexHistory.clear();
  }

  void subscribeToMeter({
    required String baseUrl,
    required String idWorkspace,
    required String idMeter,
  }) async {
    if (_authProvider?.token == null) {
      errorMessageSocket = "User not authenticated";
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
            errorMessageSocket = null;
          } catch (e) {
            errorMessageSocket = 'Error al procesar datos';
          }
          notifyListeners();
        },
      );
    } catch (e) {
      errorMessageSocket = "Error al conectar al servidor: ${e.toString()}";
      notifyListeners();
    }
  }

  Future<void> fetchMeterRecords(
    String workspaceId,
    String meterId, {
    DateTime? startDate,
    DateTime? endDate,
    String? lastId,
  }) async {
    if (_authProvider?.token == null) return;

    // Limpiar si cambió medidor o workspace
    if (_currentWorkspaceId != workspaceId || _currentMeterId != meterId) {
      meterRecordsResponse = null;
      _indexHistory.clear();
      _currentLastId = null;
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await _meterRecordsRepo.fetchMeterRecords(
        _authProvider!.token!,
        workspaceId,
        meterId,
        startDate: startDate,
        endDate: endDate,
        lastId: lastId,
      );

      if (!result.isSuccess) {
        errorMessageRecords = result.message;
        meterRecordsResponse = null;
      } else {
        final records = result.value!;
        meterRecordsResponse = records;
        errorMessageRecords = null;

        // Actualizar índice para paginación
        if (lastId != null) _indexHistory.add(lastId);
        _currentLastId = _getLastId(records);

        _currentWorkspaceId = workspaceId;
        _currentMeterId = meterId;
        _currentStartDate = startDate;
        _currentEndDate = endDate;
      }
    } catch (e) {
      errorMessageRecords = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? _getLastId(MeterRecordsResponse records) {
    final allRecords = [
      ...records.temperatureRecords,
      ...records.phRecords,
      ...records.tdsRecords,
      ...records.conductivityRecords,
      ...records.turbidityRecords,
    ];
    if (allRecords.isEmpty) return null;
    return allRecords.last.id; // Cada registro debe tener un campo 'id'
  }

  Future<void> goToNextPage() async {
    if (_currentLastId == null) return;
    await fetchMeterRecords(
      _currentWorkspaceId!,
      _currentMeterId!,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      lastId: _currentLastId,
    );
  }

  Future<void> goToPreviousPage() async {
    if (_indexHistory.isEmpty) return;
    final previousId = _indexHistory.removeLast();
    await fetchMeterRecords(
      _currentWorkspaceId!,
      _currentMeterId!,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      lastId: previousId,
    );
  }

  Future<void> applyDateFilters(DateTime? startDate, DateTime? endDate) async {
    if (_currentWorkspaceId == null || _currentMeterId == null) return;
    _indexHistory.clear();
    _currentLastId = null;
    await fetchMeterRecords(_currentWorkspaceId!, _currentMeterId!,
        startDate: startDate, endDate: endDate);
  }

  Future<void> clearFilters() async {
    _currentStartDate = null;
    _currentEndDate = null;
    _indexHistory.clear();
    _currentLastId = null;
    await fetchMeterRecords(_currentWorkspaceId!, _currentMeterId!);
  }

  Future<void> refreshMeterRecords() async {
    if (_currentWorkspaceId != null && _currentMeterId != null) {
      await fetchMeterRecords(_currentWorkspaceId!, _currentMeterId!,
          startDate: _currentStartDate, endDate: _currentEndDate);
    }
  }

  void unsubscribe() => _socketService.disconnect();
}
