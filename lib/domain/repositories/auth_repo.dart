import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/response/login_response.dart';
import 'package:frontend_water_quality/core/interface/response/verify_code_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/user.dart';

abstract class AuthRepo {
  Future<Result<LoginResponse>> login(User user);
  Future<Result<Response>> register(User user);
  Future<Result<Response>> requestPasswordReset(String email);
  Future<Result<VerifyCodeResponse>> verifyResetCode(String email, String code);
  Future<Result<Response>> resetPassword(String token, String newPassword);
}
