import 'dart:convert';
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

  User copyWith({
    String? uid,
    String? email,
    String? username,
    String? phone,
    String? password,
    AppRoles? rol,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      rol: rol ?? this.rol,
    );
  }

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

  factory User.fromString(String userString) {
    dynamic userJson = jsonDecode(userString);
    return User.fromJson(userJson);
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

  String toJsonEncode() {
    return jsonEncode(toJson());
  }
}
