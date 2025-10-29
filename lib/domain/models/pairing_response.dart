class PairingResponse {
  final String message;
  final String token;

  PairingResponse({
    required this.message,
    required this.token,
  });

  factory PairingResponse.fromJson(Map<String, dynamic> json) {
    return PairingResponse(
      message: json['message'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
    };
  }
}