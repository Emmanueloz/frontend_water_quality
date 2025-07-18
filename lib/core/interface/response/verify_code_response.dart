import 'package:frontend_water_quality/core/interface/response/base_response.dart';

class VerifyCodeResponse extends BaseResponse {
  final String? token;
  VerifyCodeResponse({
    super.message,
    this.token,
    super.detail,
  });

  factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) =>
      VerifyCodeResponse(
        message: json["message"],
        detail: json["detail"],
        token: json["token"],
      );
}
