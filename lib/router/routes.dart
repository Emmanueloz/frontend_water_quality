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
  static RouteProperties workspaces = RouteProperties(
    name: "workspaces",
    path: "/workspaces/:type",
  );
  static RouteProperties createWorkspace = RouteProperties(
    name: "createWorkspace",
    path: "/create",
    pathRoot: "/workspace/mine",
  );
  static RouteProperties workspace = RouteProperties(
    name: "workspace",
    path: "/:id",
    pathRoot: "/workspace/",
  );
  static RouteProperties updateWorkspace = RouteProperties(
    name: "updateWorkspace",
    path: "/update",
  );
  static RouteProperties profile = RouteProperties(
    name: "profile",
    path: "/profile",
  );
  static RouteProperties alerts = RouteProperties(
    name: "alerts",
    path: "/:id/alerts",
  );
  static RouteProperties meter = RouteProperties(
    name: "meters",
    path: "/meter/:idMeter",
  );
  static RouteProperties listRecords = RouteProperties(
    name: "listRecords",
    path: "/records",
  );
  static RouteProperties notificationDetails = RouteProperties(
    name: "notificationDetails",
    path: "/notification/:id",
  );
}
