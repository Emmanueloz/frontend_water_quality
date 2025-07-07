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

  Future<void> loadSettings() async {
    token = await LocalStorageService.get(StorageKey.token);
    isAuthenticated = token != null && token!.isNotEmpty;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final Result<LoginResponse> result =
        await _authRepo.login(User(email: email, password: password));

    if (result.isSuccess) {
      isAuthenticated = true;
      token = result.value?.token;
      user = result.value?.user;
      if (token != null) {
        await LocalStorageService.save(StorageKey.token, token!);
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

  void logout() {
    isAuthenticated = false;
    token = null;
    user = null;
    notifyListeners();
  }
}
