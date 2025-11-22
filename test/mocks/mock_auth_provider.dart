import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/auth_repo.dart';
import 'package:frontend_water_quality/domain/repositories/user_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

class MockAuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUserRepo implements UserRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthProvider extends AuthProvider {
  User? _mockUser;
  String? _mockToken;
  bool _isAuthenticated = false;
  bool _updateUserDataCalled = false;

  MockAuthProvider() : super(MockAuthRepo(), MockUserRepo());

  void setMockUser(User? user, String? token) {
    _mockUser = user;
    _mockToken = token;
    _isAuthenticated = user != null && token != null && token.isNotEmpty;
  }

  @override
  User? get user => _mockUser;

  @override
  String? get token => _mockToken;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  void updateUserData(User user) {
    _updateUserDataCalled = true;
    _mockUser = user;
  }

  bool get updateUserDataCalled => _updateUserDataCalled;

  void reset() {
    _mockUser = null;
    _mockToken = null;
    _isAuthenticated = false;
    _updateUserDataCalled = false;
  }
}
