import 'package:frontend_water_quality/core/enums/type_workspace.dart';
import 'package:frontend_water_quality/domain/models/user.dart';

class Workspace {
  String? id;
  String? name;
  String? owner;
  TypeWorkspace? type;
  User? user;

  Workspace({
    this.name,
    this.owner,
    this.type,
    this.id,
    this.user,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) => Workspace(
        name: json["name"],
        owner: json["owner"],
        type: json["type"] == null
            ? null
            : TypeWorkspaceExtension.fromName(json["type"]),
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data["id"] = id;
    if (name != null) data["name"] = name;
    if (owner != null) data["owner"] = owner;
    if (type != null) data["type"] = type?.name;
    if (user != null) {
      data["user"] = user!.toJson();
    }
    return data;
  }
}
