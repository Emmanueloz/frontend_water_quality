// app_router.dart
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/presentation/pages/form_workspace.dart';
import 'package:frontend_water_quality/presentation/pages/list_workspace.dart';
import 'package:frontend_water_quality/presentation/pages/login.dart';
import 'package:frontend_water_quality/presentation/pages/register.dart';
import 'package:frontend_water_quality/presentation/pages/profile.dart';
import 'package:frontend_water_quality/presentation/pages/simple.dart';
import 'package:frontend_water_quality/presentation/pages/splash.dart';
import 'package:frontend_water_quality/presentation/pages/view_listrecords.dart';
import 'package:frontend_water_quality/presentation/pages/view_meter.dart';
import 'package:frontend_water_quality/presentation/pages/view_notificationdetails.dart';
import 'package:frontend_water_quality/presentation/pages/view_workspace.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash.path,
    //debugLogDiagnostics: true, // Útil durante el desarrollo
    routes: [
      GoRoute(
        path: Routes.splash.path,
        name: Routes.splash.name,
        builder: (context, state) => Splash(),
      ),
      GoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        builder: (context, state) => const LoginPage(title: 'Login'),
      ),
      GoRoute(
        path: Routes.register.path,
        name: Routes.register.name,
        builder: (context, state) => const RegisterPage(title: 'Register'),
      ),
      GoRoute(
        path: Routes.workspaces.path,
        name: Routes.workspaces.name,
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
        routes: [
          GoRoute(
            path: Routes.createWorkspace.path,
            name: Routes.createWorkspace.name,
            builder: (context, state) {
              print("Create Workspace");
              return FormWorkspace();
            },
          ),
          GoRoute(
              path: Routes.workspace.path,
              name: Routes.workspace.name,
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? 'default';
                final typeString = state.pathParameters['type'] ?? 'mine';
                ListWorkspaces type;

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
                return ViewWorkspace(id: id, type: type);
              },
              routes: [
                GoRoute(
                    path: Routes.meter.path,
                    name: Routes.meter.name,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? 'default';
                      final idMeter =
                          state.pathParameters['idMeter'] ?? 'default';
                      final typeString = state.pathParameters['type'] ?? 'mine';
                      ListWorkspaces type;

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
                      return ViewMeter(id: id, idMeter: idMeter, type: type);
                    },
                    routes: [
                      GoRoute(
                        path: Routes.listRecords.path,
                        name: Routes.listRecords.name,
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? 'default';
                          return VieListrecords(id: id);
                        },
                      ),
                    ]),
                GoRoute(
                  path: Routes.updateWorkspace.path,
                  name: Routes.updateWorkspace.name,
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? 'default';
                    return FormWorkspace(idWorkspace: id);
                  },
                ),
              ]),
          GoRoute(
            path: Routes.alerts.path,
            name: Routes.alerts.name,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? 'default';
              return Simple(title: 'Alerts for Workspace $id');
            },
          ),
        ],
      ),
      GoRoute(
        path: Routes.profile.path,
        name: Routes.profile.name,
        builder: (context, state) => const Profile(),
      ),
      GoRoute(
        path: Routes.notificationDetails.path,
        name: Routes.notificationDetails.name,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'default';
          return NotificationDetailPage(
            title: 'Notification Details $id',
            date: DateTime.now(),
            description: "Nueva notificacion",
            qualityLevel: "buena",
            id: id,
          );
        },
      ),
    ],
  );
}
