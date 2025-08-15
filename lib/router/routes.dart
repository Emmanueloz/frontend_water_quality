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

  static RouteProperties profile = RouteProperties(
    name: "profile",
    path: "/profile",
  );

  static RouteProperties notificationDetails = RouteProperties(
    name: "notificationDetails",
    path: "/notification/:id",
  );
  static RouteProperties listNotifications = RouteProperties(
    name: "listNotifications",
    path: "/notifications",
  );

  static RouteProperties recoveryPassword = RouteProperties(
    name: "recoveryPassword",
    path: "/recovery-password",
  );
  static RouteProperties changePassword = RouteProperties(
    name: "changePassword",
    path: "/change-password",
  );

  // Workspace
  static RouteProperties workspaces = RouteProperties(
    name: "workspaces",
    path: "/workspaces",
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

  static RouteProperties alerts = RouteProperties(
    name: "alerts",
    path: "/alerts",
  );

  static RouteProperties createAlerts = RouteProperties(
    name: "createAlerts",
    path: "/create",
    pathRoot: "/alerts",
  );

  static RouteProperties updateAlerts = RouteProperties(
    name: "updateAlerts",
    path: "/:idAlert/update",
    pathRoot: "/alerts",
  );



  static RouteProperties guests = RouteProperties(
    name: "guests",
    path: "/guests",
  );

  static RouteProperties createGuest = RouteProperties(
    name: "createGuest",
    path: "/create",
    pathRoot: "/guests",
  );

  static RouteProperties editGuest = RouteProperties(
    name: "editGuest",
    path: "/:guestId/edit",
    pathRoot: "/guests",
  );

  static RouteProperties locationMeters = RouteProperties(
    name: "locationMeters",
    path: "/locations",
  );

  static RouteProperties updateWorkspace = RouteProperties(
    name: "updateWorkspace",
    path: "/update",
  );

  static RouteProperties meter = RouteProperties(
    name: "meters",
    path: "/meter/:idMeter",
  );

  static RouteProperties analysisRecords = RouteProperties(
    name: "analysis",
    path: "meter/:idMeter/analysis",
  );

  static RouteProperties connectionMeter = RouteProperties(
    name: "connectionMeter",
    path: "meter/:idMeter/connection",
  );

  static RouteProperties connectionMeterDevice = RouteProperties(
    name: "connectionDevice",
    path: "/device",
  );

  static RouteProperties updateMeter = RouteProperties(
    name: "updateMeter",
    path: "meter/:idMeter/update",
  );

  static RouteProperties createMeter = RouteProperties(
    name: "createMeter",
    path: "/meter-create",
  );

  static RouteProperties weather = RouteProperties(
    name: "weather",
    path: "meter/:idMeter/weather",
  );

  static RouteProperties listRecords = RouteProperties(
    name: "listRecords",
    path: "meter/:idMeter/records",
  );
}
