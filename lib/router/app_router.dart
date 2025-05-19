// app_router.dart
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/presentation/pages/list_workspace.dart';
import 'package:frontend_water_quality/presentation/pages/simple.dart';
import 'package:frontend_water_quality/presentation/pages/splash.dart';
import 'package:frontend_water_quality/presentation/pages/view_workspace.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash.path,
    //debugLogDiagnostics: true, // Útil durante el desarrollo
    //routerNeglect: true, // Ayuda con URLs en web
    routes: [
      GoRoute(
        path: Routes.splash.path,
        name: Routes.splash.name,
        builder: (context, state) => Splash(),
      ),
      GoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        builder: (context, state) => const Simple(title: 'Login'),
      ),
      GoRoute(
        path: Routes.register.path,
        name: Routes.register.name,
        builder: (context, state) => const Simple(title: 'Register'),
      ),
      GoRoute(
        path: Routes.listWorkspace.path,
        name: Routes.listWorkspace.name,
        builder: (context, state) {
          ListWorkspaces type;
          final typeString = state.pathParameters['type'] ?? 'mine';
          switch (typeString) {
            case 'mine':
              type = ListWorkspaces.mine;
              break;
            case 'shared':
              type = ListWorkspaces.shared;
              break;
            default:
              type = ListWorkspaces.mine;
              break;
          }

          return ListWorkspace(type: type);
        },
      ),
      GoRoute(
        path: Routes.viewWorkspace.path,
        name: Routes.viewWorkspace.name,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'default';
          return ViewWorkspace(id: id);
        },
      ),
      GoRoute(
        path: Routes.profile.path,
        name: Routes.profile.name,
        builder: (context, state) => const Simple(title: 'Profile'),
      ),
      GoRoute(
        path: Routes.alerts.path,
        name: Routes.alerts.name,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'default';
          return Simple(title: 'Alerts for Workspace $id');
        },
      ),
      GoRoute(
        path: Routes.listRecords.path,
        name: Routes.listRecords.name,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'default';
          return Simple(title: 'Records for Workspace $id');
        },
      ),
      GoRoute(
        path: Routes.notificationDetails.path,
        name: Routes.notificationDetails.name,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'default';
          return Simple(title: 'Notification Details $id');
        },
      ),
    ],
  );
}
