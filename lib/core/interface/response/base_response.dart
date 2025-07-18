class BaseResponse {
  final String? message;
  final String? detail;

  BaseResponse({
    this.message,
    this.detail,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        message: json["message"],
        detail: json["detail"],
      );
}
