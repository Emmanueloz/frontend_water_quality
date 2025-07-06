import 'package:flutter/widgets.dart';
import 'package:frontend_water_quality/core/interface/response/login_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/auth_repo.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo _authRepo;

  AuthProvider(this._authRepo);

  bool isAuthenticated = false;
  bool isLoading = false;
  String? token;
  User? user;
  String? errorMessage;

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final Result<LoginResponse> result =
        await _authRepo.login(User(email: email, password: password));
    if (result.isSuccess) {
      isAuthenticated = true;
      token = result.value?.token;
      user = result.value?.user;
    } else {
      errorMessage = result.message;
    }
    isLoading = false;
    notifyListeners();
  }

  void logout() {
    isAuthenticated = false;
    token = null;
    user = null;
    notifyListeners();
  }
}
