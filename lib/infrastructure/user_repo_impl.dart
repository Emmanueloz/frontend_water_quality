import 'package:dio/dio.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/domain/repositories/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final Dio _dio;

  UserRepoImpl(this._dio);

  @override
  Future<Result<User>> getUser(String userToken) async {
    try {
      final response = await _dio.get(
        '/users/me',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode != 200) {
        return Result.failure('Error: codigo ${response.statusCode}');
      }

      final user = User.fromJson(response.data['user']);
      return Result.success(user);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<BaseResponse>> update(String userToken, User user) async {
    try {
      final response = await _dio.put(
        '/users/me',
        data: user.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result.success(BaseResponse.fromJson(response.data));
      }

      return Result.failure('Error: codigo ${response.statusCode}');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
