import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/response/login_response.dart';
import 'package:frontend_water_quality/core/interface/response/verify_code_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final Dio _dio;

  AuthRepoImpl(this._dio);

  @override
  Future<Result<LoginResponse>> login(User user) async {
    try {
      final response = await _dio.post('/login', data: user.toJson());
      return Result.success(LoginResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Response>> register(User user) async {
    try {
      final response = await _dio.post('/register', data: user.toJson());
      return Result.success(response);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Response>> requestPasswordReset(String email) async {
    try {
      final response =
          await _dio.post('/request-password-reset', data: {'email': email});
      return Result.success(response);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<VerifyCodeResponse>> verifyResetCode(
      String email, String code) async {
    try {
      final response = await _dio
          .post('/verify-reset-code', data: {'email': email, 'code': code});
      return Result.success(VerifyCodeResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Response>> resetPassword(
      String token, String newPassword) async {
    try {
      final response = await _dio.post('/reset-password',
          data: {'token': token, 'newPassword': newPassword});
      return Result.success(response);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
