import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/response/login_response.dart';
import 'package:frontend_water_quality/core/interface/response/verify_code_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/storage_model.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/auth_repo.dart';
import 'package:frontend_water_quality/domain/repositories/user_repo.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/core/enums/roles.dart';

class MockAuthRepository implements AuthRepo {
  Result<LoginResponse>? mockLoginResult;
  Result<BaseResponse>? mockRegisterResult;
  Result<BaseResponse>? mockRequestPasswordResetResult;
  Result<VerifyCodeResponse>? mockVerifyResetCodeResult;
  Result<BaseResponse>? mockResetPasswordResult;
  Result<bool>? mockIsTokenExpiredResult;
  
  int callCount = 0;

  void reset() {
    mockLoginResult = null;
    mockRegisterResult = null;
    mockRequestPasswordResetResult = null;
    mockVerifyResetCodeResult = null;
    mockResetPasswordResult = null;
    mockIsTokenExpiredResult = null;
    callCount = 0;
  }

  @override
  Future<Result<LoginResponse>> login(User user) async {
    callCount++;
    return mockLoginResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<BaseResponse>> register(User user) async {
    callCount++;
    return mockRegisterResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<BaseResponse>> requestPasswordReset(String email) async {
    callCount++;
    return mockRequestPasswordResetResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<VerifyCodeResponse>> verifyResetCode(String email, String code) async {
    callCount++;
    return mockVerifyResetCodeResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<BaseResponse>> resetPassword(String token, String newPassword) async {
    callCount++;
    return mockResetPasswordResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<bool>> isTokenExpired(String token) async {
    callCount++;
    return mockIsTokenExpiredResult ?? Result.failure('Mock not configured');
  }
}

class MockUserRepository implements UserRepo {
  Result<User>? mockGetUserResult;
  Result<BaseResponse>? mockUpdateResult;
  Result<BaseResponse>? mockUpdatePasswordResult;
  
  int callCount = 0;

  void reset() {
    mockGetUserResult = null;
    mockUpdateResult = null;
    mockUpdatePasswordResult = null;
    callCount = 0;
  }

  @override
  Future<Result<User>> getUser(String userToken) async {
    callCount++;
    return mockGetUserResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<BaseResponse>> update(String userToken, User user) async {
    callCount++;
    return mockUpdateResult ?? Result.failure('Mock not configured');
  }

  @override
  Future<Result<BaseResponse>> updatePassword(String userToken, String newPassword) async {
    callCount++;
    return mockUpdatePasswordResult ?? Result.failure('Mock not configured');
  }
}

void main() {
  group('AuthProvider Tests', () {
    late MockAuthRepository mockAuthRepo;
    late MockUserRepository mockUserRepo;
    late AuthProvider provider;

    // Test data
    final testUser = User(
      uid: 'user_1',
      email: 'test@example.com',
      username: 'testuser',
      rol: AppRoles.admin,
    );

    final testLoginResponse = LoginResponse(
      user: testUser,
      token: 'test_token_123',
      message: 'Login successful',
    );

    setUp(() {
      mockAuthRepo = MockAuthRepository();
      mockUserRepo = MockUserRepository();
      provider = AuthProvider(mockAuthRepo, mockUserRepo);
    });

    tearDown(() {
      mockAuthRepo.reset();
      mockUserRepo.reset();
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        // Assert
        expect(provider.isAuthenticated, isFalse);
        expect(provider.isLoading, isFalse);
        expect(provider.token, isNull);
        expect(provider.user, isNull);
        expect(provider.errorMessage, isNull);
        expect(provider.emailRecovery, isNull);
      });
    });

    group('login', () {
      test('should login successfully with valid credentials', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.success(testLoginResponse);
        bool listenerCalled = false;
        provider.addListener(() {
          listenerCalled = true;
        });

        // Act
        final result = await provider.login('test@example.com', 'password123');

        // Assert
        expect(result, isTrue);
        expect(provider.isAuthenticated, isTrue);
        expect(provider.token, equals('test_token_123'));
        expect(provider.user, isNotNull);
        expect(provider.user!.email, equals('test@example.com'));
        expect(provider.errorMessage, isNull);
        expect(provider.isLoading, isFalse);
        expect(listenerCalled, isTrue);
      });

      test('should set loading state during login', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.success(testLoginResponse);
        bool loadingWasTrue = false;
        
        provider.addListener(() {
          if (provider.isLoading) {
            loadingWasTrue = true;
          }
        });

        // Act
        await provider.login('test@example.com', 'password123');

        // Assert
        expect(loadingWasTrue, isTrue);
        expect(provider.isLoading, isFalse);
      });

      test('should handle login failure with error message', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.failure('Invalid credentials');

        // Act
        final result = await provider.login('test@example.com', 'wrongpassword');

        // Assert
        expect(result, isFalse);
        expect(provider.isAuthenticated, isFalse);
        expect(provider.token, isNull);
        expect(provider.user, isNull);
        expect(provider.errorMessage, equals('Invalid credentials'));
        expect(provider.isLoading, isFalse);
      });

      test('should notify listeners on login success', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.success(testLoginResponse);
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.login('test@example.com', 'password123');

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should notify listeners on login failure', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.failure('Invalid credentials');
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.login('test@example.com', 'wrongpassword');

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('register', () {
      test('should register successfully', () async {
        // Arrange
        final registerResponse = BaseResponse(message: 'User registered successfully');
        mockAuthRepo.mockRegisterResult = Result.success(registerResponse);
        bool listenerCalled = false;
        
        provider.addListener(() {
          listenerCalled = true;
        });

        // Act
        final result = await provider.register(testUser);

        // Assert
        expect(result, isTrue);
        expect(provider.errorMessage, isNull);
        expect(provider.isLoading, isFalse);
        expect(listenerCalled, isTrue);
      });

      test('should set loading state during registration', () async {
        // Arrange
        final registerResponse = BaseResponse(message: 'User registered successfully');
        mockAuthRepo.mockRegisterResult = Result.success(registerResponse);
        bool loadingWasTrue = false;
        
        provider.addListener(() {
          if (provider.isLoading) {
            loadingWasTrue = true;
          }
        });

        // Act
        await provider.register(testUser);

        // Assert
        expect(loadingWasTrue, isTrue);
        expect(provider.isLoading, isFalse);
      });

      test('should handle registration failure', () async {
        // Arrange
        mockAuthRepo.mockRegisterResult = Result.failure('El usuario ya existe');

        // Act
        final result = await provider.register(testUser);

        // Assert
        expect(result, isFalse);
        expect(provider.errorMessage, equals('El usuario ya existe'));
        expect(provider.isLoading, isFalse);
      });

      test('should notify listeners on registration success', () async {
        // Arrange
        final registerResponse = BaseResponse(message: 'User registered successfully');
        mockAuthRepo.mockRegisterResult = Result.success(registerResponse);
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.register(testUser);

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should notify listeners on registration failure', () async {
        // Arrange
        mockAuthRepo.mockRegisterResult = Result.failure('El usuario ya existe');
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.register(testUser);

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('requestPasswordReset', () {
      test('should request password reset successfully', () async {
        // Arrange
        final resetResponse = BaseResponse(message: 'Password reset email sent');
        mockAuthRepo.mockRequestPasswordResetResult = Result.success(resetResponse);

        // Act
        final result = await provider.requestPasswordReset('test@example.com');

        // Assert
        expect(result, isTrue);
        expect(provider.errorMessage, isNull);
        expect(provider.emailRecovery, equals('test@example.com'));
        expect(provider.isLoading, isFalse);
      });

      test('should set loading state during password reset request', () async {
        // Arrange
        final resetResponse = BaseResponse(message: 'Password reset email sent');
        mockAuthRepo.mockRequestPasswordResetResult = Result.success(resetResponse);
        bool loadingWasTrue = false;
        
        provider.addListener(() {
          if (provider.isLoading) {
            loadingWasTrue = true;
          }
        });

        // Act
        await provider.requestPasswordReset('test@example.com');

        // Assert
        expect(loadingWasTrue, isTrue);
        expect(provider.isLoading, isFalse);
      });

      test('should handle password reset request failure', () async {
        // Arrange
        mockAuthRepo.mockRequestPasswordResetResult = Result.failure('User not found');

        // Act
        final result = await provider.requestPasswordReset('notfound@example.com');

        // Assert
        expect(result, isFalse);
        expect(provider.errorMessage, equals('User not found'));
        expect(provider.isLoading, isFalse);
      });

      test('should notify listeners on password reset request', () async {
        // Arrange
        final resetResponse = BaseResponse(message: 'Password reset email sent');
        mockAuthRepo.mockRequestPasswordResetResult = Result.success(resetResponse);
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.requestPasswordReset('test@example.com');

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('verifyResetCode', () {
      test('should verify reset code successfully', () async {
        // Arrange
        provider.emailRecovery = 'test@example.com';
        final verifyResponse = VerifyCodeResponse(
          token: 'reset_token_123',
          message: 'Code verified',
        );
        mockAuthRepo.mockVerifyResetCodeResult = Result.success(verifyResponse);

        // Act
        final token = await provider.verifyResetCode('123456');

        // Assert
        expect(token, equals('reset_token_123'));
        expect(provider.errorMessage, isNull);
        expect(provider.isLoading, isFalse);
      });

      test('should set loading state during code verification', () async {
        // Arrange
        provider.emailRecovery = 'test@example.com';
        final verifyResponse = VerifyCodeResponse(
          token: 'reset_token_123',
          message: 'Code verified',
        );
        mockAuthRepo.mockVerifyResetCodeResult = Result.success(verifyResponse);
        bool loadingWasTrue = false;
        
        provider.addListener(() {
          if (provider.isLoading) {
            loadingWasTrue = true;
          }
        });

        // Act
        await provider.verifyResetCode('123456');

        // Assert
        expect(loadingWasTrue, isTrue);
        expect(provider.isLoading, isFalse);
      });

      test('should handle invalid reset code', () async {
        // Arrange
        provider.emailRecovery = 'test@example.com';
        mockAuthRepo.mockVerifyResetCodeResult = Result.failure('Invalid code');

        // Act
        final token = await provider.verifyResetCode('invalid');

        // Assert
        expect(token, isNull);
        expect(provider.errorMessage, equals('Invalid code'));
        expect(provider.isLoading, isFalse);
      });

      test('should notify listeners on code verification', () async {
        // Arrange
        provider.emailRecovery = 'test@example.com';
        final verifyResponse = VerifyCodeResponse(
          token: 'reset_token_123',
          message: 'Code verified',
        );
        mockAuthRepo.mockVerifyResetCodeResult = Result.success(verifyResponse);
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.verifyResetCode('123456');

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('resetPassword', () {
      test('should reset password successfully', () async {
        // Arrange
        provider.emailRecovery = 'test@example.com';
        final resetResponse = BaseResponse(message: 'Password reset successfully');
        mockAuthRepo.mockResetPasswordResult = Result.success(resetResponse);

        // Act
        final result = await provider.resetPassword('reset_token_123', 'newPassword123');

        // Assert
        expect(result, isTrue);
        expect(provider.errorMessage, isNull);
        expect(provider.emailRecovery, isNull);
        expect(provider.isLoading, isFalse);
      });

      test('should set loading state during password reset', () async {
        // Arrange
        final resetResponse = BaseResponse(message: 'Password reset successfully');
        mockAuthRepo.mockResetPasswordResult = Result.success(resetResponse);
        bool loadingWasTrue = false;
        
        provider.addListener(() {
          if (provider.isLoading) {
            loadingWasTrue = true;
          }
        });

        // Act
        await provider.resetPassword('reset_token_123', 'newPassword123');

        // Assert
        expect(loadingWasTrue, isTrue);
        expect(provider.isLoading, isFalse);
      });

      test('should handle password reset failure', () async {
        // Arrange
        mockAuthRepo.mockResetPasswordResult = Result.failure('Token inválido');

        // Act
        final result = await provider.resetPassword('invalid_token', 'newPassword123');

        // Assert
        expect(result, isFalse);
        expect(provider.errorMessage, equals('Token inválido'));
        expect(provider.isLoading, isFalse);
      });

      test('should clear emailRecovery on successful password reset', () async {
        // Arrange
        provider.emailRecovery = 'test@example.com';
        final resetResponse = BaseResponse(message: 'Password reset successfully');
        mockAuthRepo.mockResetPasswordResult = Result.success(resetResponse);

        // Act
        await provider.resetPassword('reset_token_123', 'newPassword123');

        // Assert
        expect(provider.emailRecovery, isNull);
      });

      test('should notify listeners on password reset', () async {
        // Arrange
        final resetResponse = BaseResponse(message: 'Password reset successfully');
        mockAuthRepo.mockResetPasswordResult = Result.success(resetResponse);
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.resetPassword('reset_token_123', 'newPassword123');

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('loadSettings', () {
      test('should load settings with valid token', () async {
        // Arrange
        final storageModel = StorageModel(
          token: 'valid_token_123',
          user: testUser,
        );
        mockAuthRepo.mockIsTokenExpiredResult = Result.success(false);

        // Act
        await provider.loadSettings(storageModel);

        // Assert
        expect(provider.isAuthenticated, isTrue);
        expect(provider.token, equals('valid_token_123'));
        expect(provider.user, equals(testUser));
      });

      test('should clean auth when token is expired', () async {
        // Arrange
        final storageModel = StorageModel(
          token: 'expired_token',
          user: testUser,
        );
        mockAuthRepo.mockIsTokenExpiredResult = Result.success(true);

        // Act
        await provider.loadSettings(storageModel);

        // Assert
        expect(provider.isAuthenticated, isFalse);
        expect(provider.token, isNull);
        expect(provider.user, isNull);
      });

      test('should handle null token in storage', () async {
        // Arrange
        final storageModel = StorageModel(
          token: null,
          user: null,
        );
        mockAuthRepo.mockIsTokenExpiredResult = Result.success(true);

        // Act
        await provider.loadSettings(storageModel);

        // Assert
        expect(provider.isAuthenticated, isFalse);
        expect(provider.token, isNull);
        expect(provider.user, isNull);
      });

      test('should notify listeners when loading settings', () async {
        // Arrange
        final storageModel = StorageModel(
          token: 'valid_token_123',
          user: testUser,
        );
        mockAuthRepo.mockIsTokenExpiredResult = Result.success(false);
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        await provider.loadSettings(storageModel);

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('loginWithToken', () {
      test('should login with valid token', () async {
        // Arrange
        mockAuthRepo.mockIsTokenExpiredResult = Result.success(false);
        mockUserRepo.mockGetUserResult = Result.success(testUser);

        // Act
        final result = await provider.loginWithToken('valid_token_123');

        // Assert
        expect(result, isTrue);
        expect(provider.isAuthenticated, isTrue);
        expect(provider.token, equals('valid_token_123'));
        expect(provider.user, equals(testUser));
        expect(provider.errorMessage, isNull);
      });

      test('should handle expired token', () async {
        // Arrange
        mockAuthRepo.mockIsTokenExpiredResult = Result.success(true);

        // Act
        final result = await provider.loginWithToken('expired_token');

        // Assert
        expect(result, isFalse);
        expect(provider.isAuthenticated, isFalse);
        expect(provider.errorMessage, equals('Token inválido o expirado'));
      });

      test('should allow login when token validation fails due to network', () async {
        // Arrange
        mockAuthRepo.mockIsTokenExpiredResult = Result.failure('Network error');
        mockUserRepo.mockGetUserResult = Result.success(testUser);

        // Act
        final result = await provider.loginWithToken('valid_token_123');

        // Assert
        expect(result, isTrue);
        expect(provider.isAuthenticated, isTrue);
      });

      test('should handle exception during token login', () async {
        // Arrange
        mockAuthRepo.mockIsTokenExpiredResult = Result.success(false);
        mockUserRepo.mockGetUserResult = Result.failure('User fetch failed');

        // Act
        final result = await provider.loginWithToken('valid_token_123');

        // Assert
        expect(result, isTrue);
        expect(provider.isAuthenticated, isTrue);
        expect(provider.token, equals('valid_token_123'));
      });
    });

    group('loginWithTokenAndUser', () {
      test('should login with valid token and user', () async {
        // Arrange
        mockAuthRepo.mockIsTokenExpiredResult = Result.success(false);

        // Act
        final result = await provider.loginWithTokenAndUser('valid_token_123', testUser);

        // Assert
        expect(result, isTrue);
        expect(provider.isAuthenticated, isTrue);
        expect(provider.token, equals('valid_token_123'));
        expect(provider.user, equals(testUser));
        expect(provider.errorMessage, isNull);
      });

      test('should handle expired token with user', () async {
        // Arrange
        mockAuthRepo.mockIsTokenExpiredResult = Result.success(true);

        // Act
        final result = await provider.loginWithTokenAndUser('expired_token', testUser);

        // Assert
        expect(result, isFalse);
        expect(provider.isAuthenticated, isFalse);
        expect(provider.errorMessage, equals('Token inválido o expirado'));
      });

      test('should allow login when token validation fails due to network', () async {
        // Arrange
        mockAuthRepo.mockIsTokenExpiredResult = Result.failure('Network error');

        // Act
        final result = await provider.loginWithTokenAndUser('valid_token_123', testUser);

        // Assert
        expect(result, isTrue);
        expect(provider.isAuthenticated, isTrue);
      });
    });

    group('logout', () {
      test('should logout and clean auth state', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.success(testLoginResponse);
        await provider.login('test@example.com', 'password123');
        expect(provider.isAuthenticated, isTrue);

        // Act
        provider.logout();

        // Assert
        expect(provider.isAuthenticated, isFalse);
        expect(provider.token, isNull);
        expect(provider.user, isNull);
      });

      test('should notify listeners on logout', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.success(testLoginResponse);
        await provider.login('test@example.com', 'password123');
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        provider.logout();

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('updateUserData', () {
      test('should update user data', () {
        // Arrange
        final updatedUser = User(
          uid: 'user_1',
          email: 'updated@example.com',
          username: 'updateduser',
          rol: AppRoles.admin,
          phone: '9876543210',
        );

        // Act
        provider.updateUserData(updatedUser);

        // Assert
        expect(provider.user, equals(updatedUser));
        expect(provider.user!.email, equals('updated@example.com'));
        expect(provider.user!.phone, equals('9876543210'));
      });

      test('should notify listeners when updating user data', () {
        // Arrange
        final updatedUser = User(
          uid: 'user_1',
          email: 'updated@example.com',
          username: 'updateduser',
          rol: AppRoles.admin,
        );
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        provider.updateUserData(updatedUser);

        // Assert
        expect(notifyCount, greaterThan(0));
      });
    });

    group('cleanError', () {
      test('should clear error message', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.failure('Invalid credentials');
        await provider.login('test@example.com', 'wrongpassword');
        expect(provider.errorMessage, isNotNull);

        // Act
        provider.cleanError();

        // Assert
        expect(provider.errorMessage, isNull);
      });

      test('should notify listeners when clearing error', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.failure('Invalid credentials');
        await provider.login('test@example.com', 'wrongpassword');
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        provider.cleanError();

        // Assert
        expect(notifyCount, greaterThan(0));
      });

      test('should not notify listeners if error is already null', () {
        // Arrange
        expect(provider.errorMessage, isNull);
        int notifyCount = 0;
        
        provider.addListener(() {
          notifyCount++;
        });

        // Act
        provider.cleanError();

        // Assert
        expect(notifyCount, equals(0));
      });
    });

    group('Password Reset Flow', () {
      test('should complete full password reset flow', () async {
        // Arrange
        final resetRequestResponse = BaseResponse(message: 'Password reset email sent');
        final verifyResponse = VerifyCodeResponse(
          token: 'reset_token_123',
          message: 'Code verified',
        );
        final resetResponse = BaseResponse(message: 'Password reset successfully');
        
        mockAuthRepo.mockRequestPasswordResetResult = Result.success(resetRequestResponse);
        mockAuthRepo.mockVerifyResetCodeResult = Result.success(verifyResponse);
        mockAuthRepo.mockResetPasswordResult = Result.success(resetResponse);

        // Act & Assert - Step 1: Request reset
        final requestResult = await provider.requestPasswordReset('test@example.com');
        expect(requestResult, isTrue);
        expect(provider.emailRecovery, equals('test@example.com'));

        // Act & Assert - Step 2: Verify code
        final token = await provider.verifyResetCode('123456');
        expect(token, equals('reset_token_123'));

        // Act & Assert - Step 3: Reset password
        final resetResult = await provider.resetPassword('reset_token_123', 'newPassword123');
        expect(resetResult, isTrue);
        expect(provider.emailRecovery, isNull);
      });
    });

    group('Authentication State Management', () {
      test('should maintain authentication state across operations', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.success(testLoginResponse);
        
        // Act - Login
        await provider.login('test@example.com', 'password123');
        expect(provider.isAuthenticated, isTrue);
        
        // Update user data
        final updatedUser = User(
          uid: 'user_1',
          email: 'test@example.com',
          username: 'updateduser',
          rol: AppRoles.admin,
        );
        provider.updateUserData(updatedUser);
        
        // Assert - Still authenticated
        expect(provider.isAuthenticated, isTrue);
        expect(provider.user!.username, equals('updateduser'));
      });

      test('should clear all auth state on logout', () async {
        // Arrange
        mockAuthRepo.mockLoginResult = Result.success(testLoginResponse);
        await provider.login('test@example.com', 'password123');
        
        // Act
        provider.logout();
        
        // Assert
        expect(provider.isAuthenticated, isFalse);
        expect(provider.token, isNull);
        expect(provider.user, isNull);
      });
    });
  });
}
