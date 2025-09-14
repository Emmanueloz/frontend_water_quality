import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
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
      final resp = await _dio.post('/auth/login/', data: user.toJson());
      print(resp.data);

      LoginResponse loginResponse = LoginResponse.fromJson(resp.data);

      if (resp.statusCode != 200) {
        return Result.failure(loginResponse.detail ?? 'Login failed');
      }

      return Result.success(loginResponse);
    } catch (e) {
      print('Login error: $e');

      return Result.failure(
          'Fallo al iniciar sesión, por favor intenta más tarde');
    }
  }

  @override
  Future<Result<BaseResponse>> register(User user) async {
    try {
      final response = await _dio.post('/auth/register/', data: user.toJson());

      if (response.statusCode != 200) {
        String error;

        if (response.statusCode == 409) {
          error = "El usuario ya existe";
        } else {
          error = "Error: codigo ${response.statusCode}";
        }

        return Result.failure(error);
      }
      return Result.success(BaseResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<BaseResponse>> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        '/auth/request-password-reset/',
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        print(response.data);
        return Result.failure("Error: codigo ${response.statusCode}");
      }

      return Result.success(BaseResponse.fromJson(response.data));
    } catch (e) {
      print(e);
      if (e is DioException) {
        return Result.failure("Error de conexión");
      }
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<VerifyCodeResponse>> verifyResetCode(
      String email, String code) async {
    try {
      final response = await _dio.post(
        '/auth/verify-reset-code/',
        data: {
          'email': email,
          'code': code,
        },
      );

      print(response.statusCode);
      if (response.statusCode != 200) {
        return Result.failure("Error: codigo ${response.statusCode}");
      }

      return Result.success(VerifyCodeResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<BaseResponse>> resetPassword(
      String token, String newPassword) async {
    try {
      final response = await _dio.post(
        '/auth/reset-password/',
        queryParameters: {'token': token},
        data: {'new_password': newPassword},
      );

      if (response.statusCode != 200) {
        print(response.data);

        if (response.statusCode == 401) {
          return Result.failure("Token inválido");
        }

        return Result.failure("Error: codigo ${response.statusCode}");
      }
      return Result.success(BaseResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<bool>> isTokenExpired(String token) async {
    try {
      print("hola");
      print(_dio.options.baseUrl);
      final response = await _dio.get(
        "/users/me",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print(token);
      print(response.statusCode);

      if (response.statusCode != 200) {
        print("expiro");
        return Result.success(true);
      }
      print("No expiro");

      return Result.success(false);
    } catch (e) {
      print(e.toString());
      return Result.failure(e.toString());
    }
  }
}
