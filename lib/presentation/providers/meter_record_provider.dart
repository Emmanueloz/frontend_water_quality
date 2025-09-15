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
  bool? isSuccessSocketConnect;
  String? errorMessageSocket;
  String? errorMessageRecords;

  String? _currentWorkspaceId;
  String? _currentMeterId;
  bool _recordsLoaded = false;

  // Variables de paginación
  DateTime? _currentStartDate;
  DateTime? _currentEndDate;
  int _currentPage = 1;
  final int _pageSize = 30; // 30 registros por página
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;

  MeterRecordProvider(
      this._socketService, this._meterRecordsRepo, this._authProvider);

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  // Getters para paginación
  DateTime? get currentStartDate => _currentStartDate;
  DateTime? get currentEndDate => _currentEndDate;
  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;
  bool get hasPreviousPage => _hasPreviousPage;

  void clean() {
    recordResponse = null;
    isSuccessSocketConnect = null;
    // Limpiar registros también cuando se hace clean general
    cleanRecords();
  }

  // Método para limpiar solo datos en tiempo real (no registros)
  void cleanRealtimeData() {
    errorMessageSocket = null;
    errorMessageRecords = null;
    recordResponse = null;
  }

  // Método para limpiar registros cuando cambia el medidor o workspace
  void cleanRecords() {
    meterRecordsResponse = null;
    _currentWorkspaceId = null;
    _currentMeterId = null;
    _recordsLoaded = false;
    errorMessageSocket = null;
    errorMessageRecords = null;
    _resetPagination();
  }

  void _resetPagination() {
    _currentStartDate = null;
    _currentEndDate = null;
    _currentPage = 1;
    _hasNextPage = false;
    _hasPreviousPage = false;
  }

  void subscribeToMeter({
    required String baseUrl,
    required String idWorkspace,
    required String idMeter,
  }) async {
    if (_authProvider == null || _authProvider!.token == null) {
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
    }
  }

  Future<void> fetchMeterRecords(
    String idWorkspace, 
    String idMeter, {
    DateTime? startDate,
    DateTime? endDate,
    int? page,
  }) async {
    // Si se proporcionan fechas o página, forzar recarga
    if (startDate != null || endDate != null || page != null) {
      _recordsLoaded = false;
    }

    // Verificar si ya tenemos los datos para este medidor (sin filtros)
    if (_recordsLoaded &&
        _currentWorkspaceId == idWorkspace &&
        _currentMeterId == idMeter &&
        startDate == null &&
        endDate == null &&
        page == null) {
      return; // Ya tenemos los datos, no recargar
    }

    if (_authProvider == null || _authProvider!.token == null) {
      errorMessageRecords = "User not authenticated";
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
        startDate: startDate,
        endDate: endDate,
        page: page ?? _currentPage,
        limit: _pageSize,
      );
      
      if (!result.isSuccess) {
        errorMessageRecords = result.message;
        return;
      }

      meterRecordsResponse = result.value;
      _currentWorkspaceId = idWorkspace;
      _currentMeterId = idMeter;
      _recordsLoaded = true;
      errorMessageRecords = null;

      // Actualizar estado de paginación
      _currentStartDate = startDate;
      _currentEndDate = endDate;
      if (page != null) {
        _currentPage = page;
      }

      // Simular lógica de paginación (ajustar según la respuesta del servidor)
      _hasNextPage = _currentPage < 10; // Asumir máximo 10 páginas
      _hasPreviousPage = _currentPage > 1;

    } catch (e) {
      errorMessageRecords = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Método para aplicar filtros de fecha
  Future<void> applyDateFilters(DateTime? startDate, DateTime? endDate) async {
    if (_currentWorkspaceId == null || _currentMeterId == null) return;
    
    _currentPage = 1; // Reset a la primera página
    await fetchMeterRecords(
      _currentWorkspaceId!,
      _currentMeterId!,
      startDate: startDate,
      endDate: endDate,
      page: 1,
    );
  }

  // Método para navegar a la página anterior (solo actualiza la vista)
  Future<void> goToPreviousPage() async {
    if (!_hasPreviousPage || _currentWorkspaceId == null || _currentMeterId == null) return;
    
    // Solo actualizar la vista sin recargar datos
    _currentPage--;
    _updatePaginationState();
    notifyListeners();
  }

  // Método para navegar a la página siguiente (solo actualiza la vista)
  Future<void> goToNextPage() async {
    if (!_hasNextPage || _currentWorkspaceId == null || _currentMeterId == null) return;
    
    // Solo actualizar la vista sin recargar datos
    _currentPage++;
    _updatePaginationState();
    notifyListeners();
  }

  // Método para actualizar el estado de paginación
  void _updatePaginationState() {
    _hasNextPage = _currentPage < 10; // Asumir máximo 10 páginas
    _hasPreviousPage = _currentPage > 1;
  }

  // Método para recarga manual (igual que antes)
  Future<void> refreshMeterRecords() async {
    if (_currentWorkspaceId != null && _currentMeterId != null) {
      _recordsLoaded = false; // Forzar recarga
      await fetchMeterRecords(
        _currentWorkspaceId!,
        _currentMeterId!,
        startDate: _currentStartDate,
        endDate: _currentEndDate,
        page: _currentPage,
      );
    }
  }

  void unsubscribe() {
    _socketService.disconnect();
  }
}
