import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/response/login_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/storage_model.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/auth_repo.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';
import 'package:frontend_water_quality/domain/repositories/user_repo.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo _authRepo;
  final UserRepo _userRepo;

  AuthProvider(this._authRepo, this._userRepo);
  bool isAuthenticated = false;
  bool isLoading = false;
  String? token;
  User? user;
  String? errorMessage;

  String? emailRecovery;

  Future<void> loadSettings(StorageModel storageModel) async {
    print("Load token ${storageModel.token}");

    final Result isExpired =
        await _authRepo.isTokenExpired(storageModel.token ?? "");
    if (isExpired.value == true) {
      _cleanAuth();
      return;
    }
    token = storageModel.token;
    print(token);
    isAuthenticated = token != null && token!.isNotEmpty;
    print(isAuthenticated);

    user = storageModel.user;
    print(user);

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final Result<LoginResponse> result =
        await _authRepo.login(User(email: email, password: password));

    if (result.isSuccess) {
      isAuthenticated = true;
      print(result.value);
      token = result.value?.token;
      user = result.value?.user;
      if (token != null) {
        await LocalStorageService.save(StorageKey.token, token!);
      }

      if (user != null) {
        await LocalStorageService.save(
          StorageKey.user,
          User(
            email: user!.email,
            username: user!.username,
            rol: user!.rol,
            uid: user!.uid,
          ).toJsonEncode(),
        );
      }

      errorMessage = null;
    } else {
      errorMessage = result.message;
    }
    isLoading = false;

    notifyListeners();
    return isAuthenticated;
  }

  Future<bool> loginWithTokenAndUser(String token, User user) async {
    isLoading = true;
    notifyListeners();

    try {
      final Result<bool> isExpired = await _authRepo.isTokenExpired(token);
      // Permitir login si la validación de expiración falla por red/CORS
      final bool allow = !isExpired.isSuccess ? true : (isExpired.value == false);

      if (allow) {
        this.token = token;
        this.user = user;
        isAuthenticated = true;

        await LocalStorageService.save(StorageKey.token, token);
        await LocalStorageService.save(
          StorageKey.user,
          User(
            email: user.email,
            username: user.username,
            rol: user.rol,
            uid: user.uid,
          ).toJsonEncode(),
        );

        errorMessage = null;
      } else {
        errorMessage = 'Token inválido o expirado';
        _cleanAuth();
      }
    } catch (e) {
      errorMessage = 'No se pudo iniciar sesión con GitHub';
      _cleanAuth();
    }

    isLoading = false;
    notifyListeners();
    return isAuthenticated;
  }

  Future<bool> register(User user) async {
    isLoading = true;
    notifyListeners();

    final Result<BaseResponse> result = await _authRepo.register(user);

    if (result.isSuccess) {
      errorMessage = null;
    } else {
      errorMessage = result.message;
    }

    isLoading = false;
    notifyListeners();
    return result.isSuccess;
  }

  Future<bool> requestPasswordReset(String email) async {
    isLoading = true;
    notifyListeners();

    final result = await _authRepo.requestPasswordReset(email);

    print(result.isSuccess);

    if (result.isSuccess) {
      errorMessage = null;
      emailRecovery = email;
    } else {
      errorMessage = result.message;
    }

    isLoading = false;
    notifyListeners();
    return result.isSuccess;
  }

  Future<String?> verifyResetCode(String code) async {
    isLoading = true;
    notifyListeners();

    final result = await _authRepo.verifyResetCode(emailRecovery!, code);

    if (result.isSuccess) {
      errorMessage = null;
      isLoading = false;
      notifyListeners();
      print(result.value!.token);
      return result.value!.token;
    } else {
      errorMessage = result.message;
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    isLoading = true;
    notifyListeners();

    final result = await _authRepo.resetPassword(token, newPassword);

    if (result.isSuccess) {
      emailRecovery = null;
      errorMessage = null;
    } else {
      errorMessage = result.message;
    }
    isLoading = false;
    notifyListeners();

    return result.isSuccess;
  }

  Future<bool> loginWithToken(String token) async {
    isLoading = true;
    notifyListeners();

    try {
      final Result<bool> isExpired = await _authRepo.isTokenExpired(token);
      // Permitir login si la validación de expiración falla por red/CORS
      final bool allow = !isExpired.isSuccess ? true : (isExpired.value == false);

      if (allow) {
        this.token = token;
        isAuthenticated = true;

        await LocalStorageService.save(StorageKey.token, token);
        // Obtener y persistir el usuario para que la sesión quede igual que email/contraseña
        final userRes = await _userRepo.getUser(token);
        if (userRes.isSuccess && userRes.value != null) {
          user = userRes.value;
          await LocalStorageService.save(
            StorageKey.user,
            User(
              email: user!.email,
              username: user!.username,
              rol: user!.rol,
              uid: user!.uid,
            ).toJsonEncode(),
          );
        }

        errorMessage = null;
      } else {
        errorMessage = 'Token inválido o expirado';
        _cleanAuth();
      }
    } catch (e) {
      errorMessage = 'No se pudo iniciar sesión con GitHub';
      _cleanAuth();
    }

    isLoading = false;
    notifyListeners();
    return isAuthenticated;
  }

  void cleanError() {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }

  void _cleanAuth() {
    isAuthenticated = false;
    token = null;
    user = null;
    LocalStorageService.remove(StorageKey.token);
    LocalStorageService.remove(StorageKey.user);
    LocalStorageService.remove(StorageKey.token);
    LocalStorageService.remove(StorageKey.workspaceId);
    LocalStorageService.remove(StorageKey.meterId);
  }

  void logout() {
    _cleanAuth();
    notifyListeners();
  }
}
