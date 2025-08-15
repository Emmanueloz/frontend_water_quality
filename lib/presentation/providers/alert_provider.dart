import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/domain/repositories/alert_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class AlertProvider with ChangeNotifier {
  final AlertRepository _alertRepository;
  AuthProvider? _authProvider;

  AlertProvider(this._alertRepository, this._authProvider);

  List<Alert> _alerts = [];
  List<Alert> get alerts => _alerts;

  Alert? _selectedAlert;
  Alert? get selectedAlert => _selectedAlert;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _recharge = true;
  bool get recharge => _recharge;

  String? _currentWorkspaceId;
  String? get currentWorkspaceId => _currentWorkspaceId;

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  void setWorkspaceId(String workspaceId) {
    // Solo recargar si es un workspace diferente
    if (_currentWorkspaceId != workspaceId) {
      _currentWorkspaceId = workspaceId;
      _recharge = true;
      clean();
    }
  }

  void forceReload() {
    _recharge = true;
    if (_currentWorkspaceId != null) {
      loadAlerts();
    }
  }

  void clean() {
    _alerts = [];
    _selectedAlert = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void cleanError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void setSelectedAlert(Alert? alert) {
    _selectedAlert = alert;
    notifyListeners();
  }

  Future<void> loadAlerts() async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    // Solo cargar si es necesario recargar
    if (!_recharge) {
      print('AlertProvider: loadAlerts skipped - no recharge needed');
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('AlertProvider: loadAlerts called');
      print('AlertProvider: token = ${_authProvider!.token}');
      
      final result = await _alertRepository.listAlerts(_authProvider!.token!);
      
      print('AlertProvider: loadAlerts result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        _alerts = result.value!;
        _recharge = false;
        print('AlertProvider: loadAlerts success, loaded ${_alerts.length} alerts');
      } else {
        _errorMessage = result.message;
        print('AlertProvider: loadAlerts failed: ${result.message}');
      }
    } catch (e) {
      print('AlertProvider: loadAlerts exception: $e');
      _errorMessage = 'Error inesperado al cargar alertas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAlertDetails(String alertId) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('AlertProvider: getAlertDetails called for alertId=$alertId');
      
      final result = await _alertRepository.getAlertDetails(_authProvider!.token!, alertId);
      
      print('AlertProvider: getAlertDetails result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        _selectedAlert = result.value!;
        print('AlertProvider: getAlertDetails success');
      } else {
        _errorMessage = result.message;
        print('AlertProvider: getAlertDetails failed: ${result.message}');
      }
    } catch (e) {
      print('AlertProvider: getAlertDetails exception: $e');
      _errorMessage = 'Error inesperado al obtener detalles: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAlert(Map<String, dynamic> alertData) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('AlertProvider: createAlert called');
      
      final result = await _alertRepository.createAlert(_authProvider!.token!, alertData);
      
      print('AlertProvider: createAlert result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        // Recargar la lista de alertas después de crear
        _recharge = true;
        await loadAlerts();
        print('AlertProvider: createAlert success');
      } else {
        _errorMessage = result.message;
        print('AlertProvider: createAlert failed: ${result.message}');
      }
    } catch (e) {
      print('AlertProvider: createAlert exception: $e');
      _errorMessage = 'Error inesperado al crear: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAlert(String alertId, Map<String, dynamic> alertData) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('AlertProvider: updateAlert called for alertId=$alertId');
      
      final result = await _alertRepository.updateAlert(_authProvider!.token!, alertId, alertData);
      
      print('AlertProvider: updateAlert result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        // Actualizar la alerta en la lista
        final index = _alerts.indexWhere((a) => a.id == alertId);
        if (index != -1) {
          _alerts[index] = result.value!;
        }
        
        // Si es la alerta seleccionada, actualizarla también
        if (_selectedAlert?.id == alertId) {
          _selectedAlert = result.value!;
        }
        
        print('AlertProvider: updateAlert success');
      } else {
        _errorMessage = result.message;
        print('AlertProvider: updateAlert failed: ${result.message}');
      }
    } catch (e) {
      print('AlertProvider: updateAlert exception: $e');
      _errorMessage = 'Error inesperado al actualizar: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAlert(String alertId) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('AlertProvider: deleteAlert called for alertId=$alertId');
      
      final result = await _alertRepository.deleteAlert(_authProvider!.token!, alertId);
      
      print('AlertProvider: deleteAlert result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        // Remover la alerta de la lista
        _alerts.removeWhere((a) => a.id == alertId);
        
        // Si es la alerta seleccionada, limpiarla
        if (_selectedAlert?.id == alertId) {
          _selectedAlert = null;
        }
        
        print('AlertProvider: deleteAlert success');
      } else {
        _errorMessage = result.message;
        print('AlertProvider: deleteAlert failed: ${result.message}');
      }
    } catch (e) {
      print('AlertProvider: deleteAlert exception: $e');
      _errorMessage = 'Error inesperado al eliminar: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAlertNotifications() async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('AlertProvider: loadAlertNotifications called');
      
      final result = await _alertRepository.getAlertNotifications(_authProvider!.token!);
      
      print('AlertProvider: loadAlertNotifications result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        // Aquí podrías manejar las notificaciones de alertas si las necesitas
        print('AlertProvider: loadAlertNotifications success, loaded ${result.value!.length} notifications');
      } else {
        _errorMessage = result.message;
        print('AlertProvider: loadAlertNotifications failed: ${result.message}');
      }
    } catch (e) {
      print('AlertProvider: loadAlertNotifications exception: $e');
      _errorMessage = 'Error inesperado al cargar notificaciones: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('AlertProvider: markNotificationAsRead called for notificationId=$notificationId');
      
      final result = await _alertRepository.markNotificationAsRead(_authProvider!.token!, notificationId);
      
      print('AlertProvider: markNotificationAsRead result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        print('AlertProvider: markNotificationAsRead success');
      } else {
        _errorMessage = result.message;
        print('AlertProvider: markNotificationAsRead failed: ${result.message}');
      }
    } catch (e) {
      print('AlertProvider: markNotificationAsRead exception: $e');
      _errorMessage = 'Error inesperado al marcar como leída: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Getters útiles
  List<Alert> get activeAlerts => _alerts.where((a) => a.isActive).toList();
  List<Alert> get inactiveAlerts => _alerts.where((a) => !a.isActive).toList();
  int get activeCount => activeAlerts.length;
  int get totalCount => _alerts.length;
  
  // Métodos para filtrar por tipo
  List<Alert> getAlertsByType(String type) => _alerts.where((a) => a.type.toLowerCase() == type.toLowerCase()).toList();
  List<Alert> getBuenoAlerts() => getAlertsByType('bueno');
  List<Alert> getMaloAlerts() => getAlertsByType('malo');
  List<Alert> getInaceptableAlerts() => getAlertsByType('inaceptable');
} 