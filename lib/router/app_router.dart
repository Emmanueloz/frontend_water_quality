// app_router.dart
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/presentation/pages/alerts.dart';
import 'package:frontend_water_quality/presentation/pages/change_password.dart';
import 'package:frontend_water_quality/presentation/pages/register_meter.dart';
import 'package:frontend_water_quality/presentation/pages/form_workspace.dart';
import 'package:frontend_water_quality/presentation/pages/guests.dart';
import 'package:frontend_water_quality/presentation/pages/list_workspace.dart';
import 'package:frontend_water_quality/presentation/pages/login.dart';
import 'package:frontend_water_quality/presentation/pages/recovery_password.dart';
import 'package:frontend_water_quality/presentation/pages/register.dart';
import 'package:frontend_water_quality/presentation/pages/profile.dart';
import 'package:frontend_water_quality/presentation/pages/simple.dart';
import 'package:frontend_water_quality/presentation/pages/splash.dart';
import 'package:frontend_water_quality/presentation/pages/view_list_records.dart';
import 'package:frontend_water_quality/presentation/pages/view_meter.dart';
import 'package:frontend_water_quality/presentation/pages/view_list_notifications.dart';
import 'package:frontend_water_quality/presentation/pages/view_meter_connection.dart';
import 'package:frontend_water_quality/presentation/pages/view_meter_ubications.dart';
import 'package:frontend_water_quality/presentation/pages/view_notification_details.dart';
import 'package:frontend_water_quality/presentation/pages/view_workspace.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_meters.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_workspace.dart';
import 'package:frontend_water_quality/presentation/pages/weather_page.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> shellMeterNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellWorkspaceNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static ListWorkspaces _getTypeWorkspace(String? typeString) {
    switch (typeString) {
      case 'mine':
        return ListWorkspaces.mine;
      case 'shared':
        return ListWorkspaces.shared;
      default:
        return ListWorkspaces.mine;
    }
  }

  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash.path,
    //debugLogDiagnostics: true, // Útil durante el desarrollo
    navigatorKey: rootNavigatorKey,
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
          final type = _getTypeWorkspace(state.uri.queryParameters['type']);
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
          ShellRoute(
            navigatorKey: shellWorkspaceNavigatorKey,
            builder: (context, state, child) {
              final id = state.pathParameters['id'] ?? 'default';
              // El índice seleccionado puede calcularse según la ruta activa
              return LayoutWorkspace(
                title: 'Espacio de trabajo $id',
                id: id,
                builder: (context, screenSize) => child,
              );
            },
            routes: [
              GoRoute(
                path: Routes.workspace.path,
                name: Routes.workspace.name,
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? 'default';
                  return ViewWorkspace(id: id);
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: Routes.createMeter.path,
                    name: Routes.createMeter.name,
                    builder: (context, state) {
                      return RegisterMeterPage(
                        idWorkspace: '-OVj_HeREMFpscqbEp5V',
                      );
                    },
                  ),
                  ShellRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    navigatorKey: shellMeterNavigatorKey,
                    builder: (context, state, child) {
                      final id = state.pathParameters['id'] ?? 'default';
                      final idMeter =
                          state.pathParameters['idMeter'] ?? 'default';
                      return LayoutMeters(
                        title: 'Medidor $idMeter',
                        id: id,
                        idMeter: idMeter,
                        builder: (context, screenSize) => child,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: Routes.meter.path,
                        name: Routes.meter.name,
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? 'default';
                          final idMeter =
                              state.pathParameters['idMeter'] ?? 'default';
                          return ViewMeter(id: id, idMeter: idMeter);
                        },
                      ),
                      GoRoute(
                        path: Routes.listRecords.path,
                        name: Routes.listRecords.name,
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? 'default';
                          final idMeter =
                              state.pathParameters['idMeter'] ?? 'default';
                          return ViewListRecords(id: id, idMeter: idMeter);
                        },
                      ),
                      GoRoute(
                        path: Routes.predictions.path,
                        name: Routes.predictions.name,
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? 'default';
                          final idMeter =
                              state.pathParameters['idMeter'] ?? 'default';
                          return SizedBox(
                            child: Text('Predicciones $id $idMeter'),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: Routes.predictionCreate.path,
                            name: Routes.predictionCreate.name,
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) {
                              return Simple(title: "Create prediction");
                            },
                          ),
                          GoRoute(
                            path: Routes.prediction.path,
                            name: Routes.prediction.name,
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) {
                              return Simple(title: "Prediction Detail");
                            },
                          ),
                        ],
                      ),
                      GoRoute(
                        path: Routes.interpretations.path,
                        name: Routes.interpretations.name,
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? 'default';
                          final idMeter =
                              state.pathParameters['idMeter'] ?? 'default';
                          return SizedBox(
                            child: Text('Interpretaciones $id $idMeter'),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: Routes.interpretationCreate.path,
                            name: Routes.interpretationCreate.name,
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) {
                              return Simple(title: "Crear interpretación");
                            },
                          ),
                          GoRoute(
                            path: Routes.interpretation.path,
                            name: Routes.interpretation.name,
                            parentNavigatorKey: rootNavigatorKey,
                            builder: (context, state) {
                              return Simple(title: "Interpretación");
                            },
                          ),
                        ],
                      ),
                      GoRoute(
                        path: Routes.connectionMeter.path,
                        name: Routes.connectionMeter.name,
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? 'default';
                          final idMeter =
                              state.pathParameters['idMeter'] ?? 'default';
                          return ViewMeterConnection(
                            id: id,
                            idMeter: idMeter,
                            title: 'Conexión del medidor $idMeter',
                          );
                        },
                      ),
                      GoRoute(
                        path: Routes.weather.path,
                        name: Routes.weather.name,
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? 'default';
                          final idMeter =
                              state.pathParameters['idMeter'] ?? 'default';
                          return WeatherPage(
                            id: id,
                            idMeter: idMeter,
                          );
                        },
                      ),
                      GoRoute(
                        path: Routes.updateMeter.path,
                        name: Routes.updateMeter.name,
                        builder: (context, state) {
                          final idWorkspace = state.pathParameters['id'] ?? 'default';
                          final idMeter =
                              state.pathParameters['idMeter'] ?? 'default';
                          return RegisterMeterPage(idWorkspace: idWorkspace, idMeter: idMeter,);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: Routes.alerts.path,
                    name: Routes.alerts.name,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? 'default';
                      return AlertsScreen(idWorkspace: id);
                    },
                    routes: [
                      GoRoute(
                        path: Routes.createAlerts.path,
                        name: Routes.createAlerts.name,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          return Simple(title: "Create Alert");
                        },
                      ),
                      GoRoute(
                        path: Routes.updateAlerts.path,
                        name: Routes.updateAlerts.name,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          return Simple(title: "Update Alert");
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: Routes.guests.path,
                    name: Routes.guests.name,
                    builder: (context, state) {
                      String id = state.pathParameters['id'] ?? 'default';
                      return GuestsPage(
                        id: id,
                        title: 'Invitados',
                      );
                    },
                  ),
                  GoRoute(
                    path: Routes.locationMeters.path,
                    name: Routes.locationMeters.name,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? 'default';
                      return ViewMeterUbications(id: id);
                    },
                  ),
                  GoRoute(
                    path: Routes.updateWorkspace.path,
                    name: Routes.updateWorkspace.name,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? 'default';
                      return FormWorkspace(idWorkspace: id);
                    },
                  ),
                ],
              ),
            ],
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
      GoRoute(
        path: Routes.listNotifications.path,
        name: Routes.listNotifications.name,
        builder: (context, state) => const ViewListNotifications(),
      ),
      GoRoute(
        path: Routes.recoveryPassword.path,
        name: Routes.recoveryPassword.name,
        builder: (context, state) => RecoveryPasswordPage(),
      ),
      GoRoute(
        path: Routes.changePassword.path,
        name: Routes.changePassword.name,
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];

          return ChangePasswordPage(
            token: token,
          );
        },
      )
    ],
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final List<String> publicRoutes = [
        Routes.splash.path,
        Routes.login.path,
        Routes.register.path,
        Routes.recoveryPassword.path,
        Routes.changePassword.path,
      ];

      final isOnPublicRoute = publicRoutes.contains(state.uri.path);

      authProvider.cleanError();

      if (!authProvider.isAuthenticated && !isOnPublicRoute) {
        return Routes.login.path;
      }

      if (authProvider.isAuthenticated && isOnPublicRoute) {
        return Routes.workspaces.path;
      }

      return null;
    },
  );
}
