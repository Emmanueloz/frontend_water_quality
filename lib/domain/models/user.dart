import 'package:frontend_water_quality/core/enums/roles.dart';

class User {
  final String? uid;
  final String email;
  final String? username;
  final String? phone;
  final String? password;
  final AppRoles? rol;

  User({
    this.uid,
    required this.email,
    this.username,
    this.phone,
    this.password,
    this.rol,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String?,
      email: json['email'] as String,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      rol: json['rol'] != null
          ? AppRoles.values.firstWhere(
              (e) => e.name == json['rol'],
              orElse: () => AppRoles.unknown,
            )
          : AppRoles.unknown,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (uid != null) data['uid'] = uid;
    data['email'] = email;
    if (username != null) data['username'] = username;
    if (phone != null) data['phone'] = phone;
    if (password != null) data['password'] = password;
    if (rol != null) data['rol'] = rol!.name;
    return data;
  }
}
