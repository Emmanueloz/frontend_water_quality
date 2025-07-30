// presentation/providers/guest_provider.dart
import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/domain/repositories/guest_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/infrastructure/dio_provider.dart';
import 'package:frontend_water_quality/infrastructure/guest_repo_impl.dart';

class GuestProvider with ChangeNotifier {
  AuthProvider? _authProvider;
  GuestRepository? _guestRepository;

  GuestProvider(this._guestRepository, this._authProvider);

  List<Guest> _guests = [];
  List<Guest> get guests => _guests;

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
    // Recrear el repositorio con el token actualizado
    if (provider != null && provider.token != null) {
      final dio = DioProvider.createDio();
      dio.options.headers['Authorization'] = 'Bearer ${provider.token}';
      _guestRepository = GuestRepositoryImpl(dio);
    }
  }

  void setWorkspaceId(String workspaceId) {
    _currentWorkspaceId = workspaceId;
    _recharge = true;
    clean();
  }

  void clean() {
    _guests = [];
    _isLoading = false;
    _errorMessage = null;
    _recharge = true;
    notifyListeners();
  }

  void cleanError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> loadGuests(String workspaceId) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    if (!_recharge) return;

    // Asegurar que el repositorio tenga el token actualizado
    if (_guestRepository == null) {
      final dio = DioProvider.createDio();
      dio.options.headers['Authorization'] = 'Bearer ${_authProvider!.token}';
      _guestRepository = GuestRepositoryImpl(dio);
    }

    _isLoading = true;
    _errorMessage = null;
    _currentWorkspaceId = workspaceId;
    notifyListeners();

    try {
      print('GuestProvider: loadGuests called for workspaceId=$workspaceId');
      print('GuestProvider: token = ${_authProvider!.token}');
      
      final result = await _guestRepository!.listGuests(workspaceId);
      
      print('GuestProvider: loadGuests result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        _guests = result.value ?? [];
        if (_guests.isEmpty) {
        _errorMessage = 'No se encontraron invitados';
        } else {
          _errorMessage = null;
        }
        print('GuestProvider: loadGuests successful, guests count=${_guests.length}');
      } else {
        _errorMessage = result.message ?? 'Error al cargar invitados';
        _guests = [];
        print('GuestProvider: loadGuests failed: $_errorMessage');
      }
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      _guests = [];
      print('GuestProvider: loadGuests exception: $e');
    } finally {
      _isLoading = false;
      _recharge = false;
      notifyListeners();
    }
  }

  Future<bool> inviteGuest(String workspaceId, String email, String role) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return false;
    }

    // Asegurar que el repositorio tenga el token actualizado
    if (_guestRepository == null) {
      final dio = DioProvider.createDio();
      dio.options.headers['Authorization'] = 'Bearer ${_authProvider!.token}';
      _guestRepository = GuestRepositoryImpl(dio);
    }

    print('GuestProvider: inviteGuest called with workspaceId=$workspaceId, email=$email, role=$role');
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _guestRepository!.inviteGuest(workspaceId, email, role);
      
      print('GuestProvider: inviteGuest result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        _guests.add(result.value!);
        _errorMessage = null;
        print('GuestProvider: inviteGuest successful, guests count=${_guests.length}');
      notifyListeners();
      return true;
      } else {
        _errorMessage = result.message ?? 'Error al invitar al invitado';
        print('GuestProvider: inviteGuest failed: $_errorMessage');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      print('GuestProvider: inviteGuest exception: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateGuestRole(String workspaceId, String guestId, String role) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return false;
    }

    // Asegurar que el repositorio tenga el token actualizado
    if (_guestRepository == null) {
      final dio = DioProvider.createDio();
      dio.options.headers['Authorization'] = 'Bearer ${_authProvider!.token}';
      _guestRepository = GuestRepositoryImpl(dio);
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _guestRepository!.updateGuestRole(workspaceId, guestId, role);
      
      if (result.isSuccess) {
      final index = _guests.indexWhere((g) => g.id == guestId);
      if (index != -1) {
          _guests[index] = result.value!;
          notifyListeners();
        }
        return true;
      } else {
        _errorMessage = result.message ?? 'Error al actualizar el rol del invitado';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteGuest(String workspaceId, String guestId) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return false;
    }

    // Asegurar que el repositorio tenga el token actualizado
    if (_guestRepository == null) {
      final dio = DioProvider.createDio();
      dio.options.headers['Authorization'] = 'Bearer ${_authProvider!.token}';
      _guestRepository = GuestRepositoryImpl(dio);
    }

    print('GuestProvider: deleteGuest called with workspaceId=$workspaceId, guestId=$guestId');
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _guestRepository!.deleteGuest(workspaceId, guestId);
      
      print('GuestProvider: deleteGuest result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        _guests.removeWhere((g) => g.id == guestId);
        print('GuestProvider: deleteGuest successful, guests count=${_guests.length}');
        notifyListeners();
      return true;
      } else {
        _errorMessage = result.message ?? 'Error al eliminar el invitado';
        print('GuestProvider: deleteGuest failed: $_errorMessage');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      print('GuestProvider: deleteGuest exception: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
