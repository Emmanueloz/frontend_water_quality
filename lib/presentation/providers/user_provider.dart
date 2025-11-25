import 'package:flutter/foundation.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/user_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class UserProvider with ChangeNotifier {
  final UserRepo _userRepo;
  AuthProvider? _authProvider;

  bool isAuthenticated = false;
  User? user;
  String? errorMessage;

  UserProvider(this._userRepo, [this._authProvider]);

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  void clean() {
    isAuthenticated = false;
    errorMessage = null;
    user = null;
    notifyListeners();
  }

  Future<Result<User>> getUser() async {
    if (_authProvider?.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      final result = await _userRepo.getUser(_authProvider!.token!);

      if (result.isSuccess) {
        return Result.success(result.value!);
      } else {
        return Result.failure(result.message ?? "Unknown error");
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<String?> updateUser(User updatedUser) async {
    if (_authProvider?.token == null) return "User not authenticated";

    try {
      final result = await _userRepo.update(_authProvider!.token!, updatedUser);

      if (result.isSuccess) {
        user = updatedUser;
        errorMessage = null;
        _authProvider?.updateUserData(updatedUser);
        notifyListeners();
      } else {
        errorMessage = result.message;
      }

      return result.message;
    } catch (e) {
      errorMessage = e.toString();
      return e.toString();
    }
  }

  Future<String?> updatePassword(String newPassword) async {
    if (_authProvider?.token == null) {
      return "User not authenticated";
    }

    try {
      final result =
          await _userRepo.updatePassword(_authProvider!.token!, newPassword);

      if (!result.isSuccess) {
        errorMessage = result.message;
      }

      return result.message;
    } catch (e) {
      errorMessage = e.toString();
      return e.toString();
    }
  }
}
