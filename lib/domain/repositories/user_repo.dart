import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/domain/models/user.dart';

abstract class UserRepo {
  Future<Result<User>> getUser(String userToken);
  Future<Result<BaseResponse>> update(String userToken, User user);
  Future<Result<BaseResponse>> updatePassword(String userToken, String newPassword);
} 