import 'package:flutter/foundation.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/user_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class UserProvider with ChangeNotifier {
  final UserRepo _userRepo;
  AuthProvider? _authProvider;

  bool isAuthenticated = false;
  bool isLoading = false;
  String? token;
  User? user;
  String? errorMessage;

  UserProvider(this._userRepo, [this._authProvider]);

  void setAuthProvider(AuthProvider? provider) {
    _authProvider = provider;
  }

  void clean() {
    isLoading = false;
    errorMessage = null;
    user = null;
    notifyListeners();
  }

  Future<Result<User>> getUser() async {
    if (_authProvider?.token == null) {
      return Result.failure("User not authenticated");
    }

    try {
      isLoading = true;
      notifyListeners();

      final result = await _userRepo.getUser(_authProvider!.token!);

      if (result.isSuccess) {
        user = result.value;
        isAuthenticated = true;
      } else {
        errorMessage = result.message;
      }

      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

Future<String?> updateUser(User updatedUser) async {
  if (_authProvider?.token == null) return "User not authenticated";

  try {
    isLoading = true;
    notifyListeners(); 

    final result = await _userRepo.update(_authProvider!.token!, updatedUser);

    if (result.isSuccess) {
      user = updatedUser;
    } else {
      errorMessage = result.message;
    }

    return result.message;
  } catch (e) {
    errorMessage = e.toString();
    return e.toString();
  } finally {
    isLoading = false;
    notifyListeners(); 
  }
}
}
