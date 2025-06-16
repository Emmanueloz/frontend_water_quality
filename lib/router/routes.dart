import 'package:frontend_water_quality/core/interface/route_properties.dart';

class Routes {
  static RouteProperties splash = RouteProperties(
    name: "splash",
    path: "/",
  );
  static RouteProperties login = RouteProperties(
    name: "login",
    path: "/login",
  );
  static RouteProperties register = RouteProperties(
    name: "register",
    path: "/register",
  );
  static RouteProperties listWorkspace = RouteProperties(
    name: "listWorkspace",
    path: "/workspaces/:type",
  );
  static RouteProperties viewWorkspace = RouteProperties(
    name: "viewWorkspace",
    path: "/:id",
    pathRoot: "/workspace/",
  );
  static RouteProperties profile = RouteProperties(
    name: "profile",
    path: "/profile",
  );
  static RouteProperties alerts = RouteProperties(
    name: "alerts",
    path: "/:id/alerts",
  );
  static RouteProperties listRecords = RouteProperties(
    name: "listRecords",
    path: "/meter/:idMeter/records",
  );
  static RouteProperties notificationDetails = RouteProperties(
    name: "notificationDetails",
    path: "/notification/:id",
  );
  static RouteProperties recoveryPassword = RouteProperties(
    name: "recoveryPassword",
    path: "/recovery-password",
  );
}
