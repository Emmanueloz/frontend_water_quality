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
  final int _pageSize = 10; // 10 registros por página
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;
  int _totalPages = 1; // Total de páginas para el filtro actual

  MeterRecordProvider(
      this._socketService, this._meterRecordsRepo, this._authProvider);

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  // Getters para paginación
  DateTime? get currentStartDate => _currentStartDate;
  DateTime? get currentEndDate => _currentEndDate;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
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
    _totalPages = 1;
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
        limit: _pageSize, // 10 registros por página
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

      // Calcular total de páginas basado en los registros recibidos
      _updatePaginationState();

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

  // Método para navegar a la página anterior (con datos reales)
  Future<void> goToPreviousPage() async {
    if (!_hasPreviousPage || _currentWorkspaceId == null || _currentMeterId == null) return;
    
    _currentPage--;
    await fetchMeterRecords(
      _currentWorkspaceId!,
      _currentMeterId!,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      page: _currentPage,
    );
  }

  // Método para navegar a la página siguiente (con datos reales)
  Future<void> goToNextPage() async {
    if (!_hasNextPage || _currentWorkspaceId == null || _currentMeterId == null) return;
    
    _currentPage++;
    await fetchMeterRecords(
      _currentWorkspaceId!,
      _currentMeterId!,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      page: _currentPage,
    );
  }

  // Método para actualizar el estado de paginación
  void _updatePaginationState() {
    if (meterRecordsResponse == null) {
      _hasNextPage = false;
      _hasPreviousPage = false;
      _totalPages = 1;
      return;
    }

    // Contar total de registros en la respuesta actual
    int currentRecords = _countCurrentRecords();
    
    // Si recibimos menos de 10 registros, no hay página siguiente
    _hasNextPage = currentRecords >= _pageSize;
    
    // Si estamos en la página 1, no hay página anterior
    _hasPreviousPage = _currentPage > 1;
    
    // Calcular total de páginas estimado
    // Si hay página siguiente, estimamos que hay al menos _currentPage + 1 páginas
    if (_hasNextPage) {
      _totalPages = _currentPage + 1; // Mínimo estimado
    } else {
      _totalPages = _currentPage; // Solo las páginas que hemos visto
    }
  }

  // Método para contar registros actuales
  int _countCurrentRecords() {
    if (meterRecordsResponse == null) return 0;
    
    int totalRecords = 0;
    if (meterRecordsResponse!.temperatureRecords.isNotEmpty) totalRecords += meterRecordsResponse!.temperatureRecords.length;
    if (meterRecordsResponse!.phRecords.isNotEmpty) totalRecords += meterRecordsResponse!.phRecords.length;
    if (meterRecordsResponse!.tdsRecords.isNotEmpty) totalRecords += meterRecordsResponse!.tdsRecords.length;
    if (meterRecordsResponse!.conductivityRecords.isNotEmpty) totalRecords += meterRecordsResponse!.conductivityRecords.length;
    if (meterRecordsResponse!.turbidityRecords.isNotEmpty) totalRecords += meterRecordsResponse!.turbidityRecords.length;
    
    return totalRecords;
  }

  // Método para recarga manual
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
