import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/response/login_response.dart';
import 'package:frontend_water_quality/core/interface/response/verify_code_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/user.dart';

abstract class AuthRepo {
  Future<Result<bool>> isTokenExpired(String toke);
  Future<Result<LoginResponse>> login(User user);
  Future<Result<BaseResponse>> register(User user);
  Future<Result<BaseResponse>> requestPasswordReset(String email);
  Future<Result<VerifyCodeResponse>> verifyResetCode(String email, String code);
  Future<Result<BaseResponse>> resetPassword(String token, String newPassword);
}
