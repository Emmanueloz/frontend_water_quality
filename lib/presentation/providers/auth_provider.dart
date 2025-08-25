import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/response/login_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/auth_repo.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo _authRepo;

  AuthProvider(this._authRepo);

  bool isAuthenticated = false;
  bool isLoading = false;
  String? token;
  User? user;
  String? errorMessage;

  String? emailRecovery;

  Future<void> loadSettings() async {
    token = await LocalStorageService.get(StorageKey.token);
    isAuthenticated = token != null && token!.isNotEmpty;
    String? userString = await LocalStorageService.get(StorageKey.user);
    if (userString != null) {
      user = User.fromString(userString);
    }

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

  void cleanError() {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }

  void logout() {
    isAuthenticated = false;
    token = null;
    user = null;
    LocalStorageService.remove(StorageKey.token);
    notifyListeners();
  }
}
