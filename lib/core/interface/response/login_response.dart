import 'package:frontend_water_quality/core/interface/response/base_response.dart';
import 'package:frontend_water_quality/domain/models/user.dart';

class LoginResponse extends BaseResponse {
  User? user;
  String? token;

  LoginResponse({
    required this.user,
    required this.token,
    super.message,
    super.detail,
  });

  @override
  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        token: json["token"],
        message: json["message"],
        detail: json["detail"],
      );
}
