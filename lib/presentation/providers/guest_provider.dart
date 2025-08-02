// presentation/providers/guest_provider.dart
import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/domain/repositories/guest_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class GuestProvider with ChangeNotifier {
  final GuestRepository _guestRepository;
  AuthProvider? _authProvider;

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
      loadGuests(_currentWorkspaceId!);
    }
  }

  void clean() {
    _guests = [];
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

  Future<void> loadGuests(String workspaceId) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    // Solo cargar si es necesario recargar o si es un workspace diferente
    if (!_recharge && _currentWorkspaceId == workspaceId) {
      print('GuestProvider: loadGuests skipped - no recharge needed');
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _currentWorkspaceId = workspaceId;
    notifyListeners();

    try {
      print('GuestProvider: loadGuests called for workspaceId=$workspaceId');
      print('GuestProvider: token = ${_authProvider!.token}');
      
      final result = await _guestRepository.listGuests(_authProvider!.token!, workspaceId);
      
      print('GuestProvider: loadGuests result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        _guests = result.value!;
        _recharge = false;
        print('GuestProvider: loadGuests success, loaded ${_guests.length} guests');
      } else {
        _errorMessage = result.message;
        print('GuestProvider: loadGuests failed: ${result.message}');
      }
    } catch (e) {
      print('GuestProvider: loadGuests exception: $e');
      _errorMessage = 'Error inesperado al cargar invitados: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> inviteGuest(String workspaceId, String email, String role) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('GuestProvider: inviteGuest called for workspaceId=$workspaceId, email=$email, role=$role');
      
      final result = await _guestRepository.inviteGuest(_authProvider!.token!, workspaceId, email, role);
      
      print('GuestProvider: inviteGuest result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        // Recargar la lista de invitados después de invitar
        _recharge = true;
        await loadGuests(workspaceId);
        print('GuestProvider: inviteGuest success');
      } else {
        _errorMessage = result.message;
        print('GuestProvider: inviteGuest failed: ${result.message}');
      }
    } catch (e) {
      print('GuestProvider: inviteGuest exception: $e');
      _errorMessage = 'Error inesperado al invitar: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateGuestRole(String workspaceId, String guestId, String role) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('GuestProvider: updateGuestRole called for workspaceId=$workspaceId, guestId=$guestId, role=$role');
      
      final result = await _guestRepository.updateGuestRole(_authProvider!.token!, workspaceId, guestId, role);
      
      print('GuestProvider: updateGuestRole result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        // Actualizar el invitado en la lista local
        final index = _guests.indexWhere((guest) => guest.id == guestId);
        if (index != -1) {
          _guests[index] = result.value!;
          notifyListeners();
        }
        print('GuestProvider: updateGuestRole success');
      } else {
        _errorMessage = result.message;
        print('GuestProvider: updateGuestRole failed: ${result.message}');
      }
    } catch (e) {
      print('GuestProvider: updateGuestRole exception: $e');
      _errorMessage = 'Error inesperado al actualizar: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteGuest(String workspaceId, String guestId) async {
    if (_authProvider == null || _authProvider!.token == null) {
      _errorMessage = "Usuario no autenticado";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('GuestProvider: deleteGuest called with workspaceId=$workspaceId, guestId=$guestId');
      
      final result = await _guestRepository.deleteGuest(_authProvider!.token!, workspaceId, guestId);
      
      print('GuestProvider: deleteGuest result isSuccess=${result.isSuccess}');
      
      if (result.isSuccess) {
        // Remover el invitado de la lista local
        _guests.removeWhere((guest) => guest.id == guestId);
        notifyListeners();
        print('GuestProvider: deleteGuest success');
      } else {
        _errorMessage = result.message;
        print('GuestProvider: deleteGuest failed: ${result.message}');
      }
    } catch (e) {
      print('GuestProvider: deleteGuest exception: $e');
      _errorMessage = 'Error inesperado al eliminar: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
