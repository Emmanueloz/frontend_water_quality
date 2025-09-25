// app_router.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';
import 'package:frontend_water_quality/presentation/pages/alerts.dart';
import 'package:frontend_water_quality/presentation/pages/analysis/analysis.dart';
import 'package:frontend_water_quality/presentation/pages/analysis/average_page.dart';
import 'package:frontend_water_quality/presentation/pages/analysis/average_period_page.dart';
import 'package:frontend_water_quality/presentation/pages/analysis/prediction_page.dart';
import 'package:frontend_water_quality/presentation/pages/form_alert.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/presentation/pages/change_password.dart';
import 'package:frontend_water_quality/presentation/pages/connection_meter.dart';
import 'package:frontend_water_quality/presentation/pages/device_meter.dart';
import 'package:frontend_water_quality/presentation/pages/error_page.dart';
import 'package:frontend_water_quality/presentation/pages/form_workspace_page.dart';
import 'package:frontend_water_quality/presentation/pages/guests.dart';
import 'package:frontend_water_quality/presentation/pages/list_workspace.dart';
import 'package:frontend_water_quality/presentation/pages/login.dart';
import 'package:frontend_water_quality/presentation/pages/recovery_password.dart';
import 'package:frontend_water_quality/presentation/pages/register.dart';
import 'package:frontend_water_quality/presentation/pages/profile.dart';
import 'package:frontend_water_quality/presentation/pages/form_meter_page.dart';
import 'package:frontend_water_quality/presentation/pages/about_us.dart';
import 'package:frontend_water_quality/presentation/pages/splash.dart';
import 'package:frontend_water_quality/presentation/pages/view_list_records.dart';
import 'package:frontend_water_quality/presentation/pages/view_meter.dart';
import 'package:frontend_water_quality/presentation/pages/view_list_notifications.dart';
import 'package:frontend_water_quality/presentation/pages/view_meter_full_screen.dart';
import 'package:frontend_water_quality/presentation/pages/view_meter_ubications.dart';
import 'package:frontend_water_quality/presentation/pages/view_notification_details.dart';
import 'package:frontend_water_quality/presentation/pages/list_meter.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_meters.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_workspace.dart';
import 'package:frontend_water_quality/presentation/pages/weather_page.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/pages/form_invite_guest.dart';
import 'package:frontend_water_quality/presentation/providers/guest_provider.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';

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
      case 'all':
        return ListWorkspaces.all;
      default:
        return ListWorkspaces.mine;
    }
  }

  static FutureOr<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    print("redirect");

    if (state.uri.path == Routes.splash.path) {
      return null;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final List<String> publicRoutes = [
      Routes.login.path,
      Routes.register.path,
      Routes.recoveryPassword.path,
      Routes.changePassword.path,
    ];

    print(state.uri.path);
    print(authProvider.isAuthenticated);

    final isOnPublicRoute = publicRoutes.contains(state.uri.path);
    print(isOnPublicRoute);

    authProvider.cleanError();

    if (!authProvider.isAuthenticated && !isOnPublicRoute) {
      return Routes.login.path;
    }

    if (authProvider.isAuthenticated && isOnPublicRoute) {
      String? workspaceId =
          await LocalStorageService.get(StorageKey.workspaceId);
      String? meterId = await LocalStorageService.get(StorageKey.meterId);

      if (workspaceId != null &&
          workspaceId.isNotEmpty &&
          meterId != null &&
          meterId.isNotEmpty) {
        return '/workspaces/$workspaceId/meter/$meterId';
      }

      if (workspaceId != null && workspaceId.isNotEmpty) {
        return '/workspaces/$workspaceId';
      }

      return Routes.workspaces.path;
    }

    return null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash.path,
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: Routes.splash.path,
        name: Routes.splash.name,
        builder: (context, state) => const Splash(),
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
        path: Routes.aboutUs.path,
        name: Routes.aboutUs.name,
        builder: (context, state) => const AboutUsPage(),
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
              return FormWorkspacePage();
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
                  return ListMeter(
                    idWorkspace: id,
                  );
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: Routes.createMeter.path,
                    name: Routes.createMeter.name,
                    builder: (context, state) {
                      return FormMeterPage(
                        idWorkspace: state.pathParameters['id'] ?? 'default',
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
                        routes: [
                          GoRoute(
                            parentNavigatorKey: rootNavigatorKey,
                            path: Routes.meterFullscreen.path,
                            name: Routes.meterFullscreen.name,
                            builder: (context, state) => ViewMeterFullScreen(
                              id: state.pathParameters['id'] ?? 'default',
                              idMeter:
                                  state.pathParameters['idMeter'] ?? 'default',
                            ),
                          )
                        ],
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
                        path: Routes.analysisRecords.path,
                        name: Routes.analysisRecords.name,
                        builder: (context, state) {
                          return AnalysisPage(
                            idWorkspace:
                                state.pathParameters['id'] ?? 'default',
                            idMeter:
                                state.pathParameters['idMeter'] ?? 'default',
                          );
                        },
                        routes: [
                          GoRoute(
                            parentNavigatorKey: rootNavigatorKey,
                            path: Routes.analysisAverage.path,
                            name: Routes.analysisAverage.name,
                            builder: (context, state) => AveragePage(
                              idWorkspace:
                                  state.pathParameters['id'] ?? 'default',
                              idMeter:
                                  state.pathParameters['idMeter'] ?? 'default',
                            ),
                          ),
                          GoRoute(
                            parentNavigatorKey: rootNavigatorKey,
                            path: Routes.analysisAveragePeriod.path,
                            name: Routes.analysisAveragePeriod.name,
                            builder: (context, state) => AveragePeriodPage(
                              idWorkspace:
                                  state.pathParameters['id'] ?? 'default',
                              idMeter:
                                  state.pathParameters['idMeter'] ?? 'default',
                            ),
                          ),
                          GoRoute(
                            parentNavigatorKey: rootNavigatorKey,
                            path: Routes.analysisPrediction.path,
                            name: Routes.analysisPrediction.name,
                            builder: (context, state) => PredictionPage(
                              idWorkspace:
                                  state.pathParameters['id'] ?? 'default',
                              idMeter:
                                  state.pathParameters['idMeter'] ?? 'default',
                            ),
                          ),
                          GoRoute(
                            parentNavigatorKey: rootNavigatorKey,
                            path: Routes.analysisCorrelation.path,
                            name: Routes.analysisCorrelation.name,
                            builder: (context, state) => SafeArea(
                              child: Text("Correlación"),
                            ),
                          )
                        ],
                      ),
                      GoRoute(
                          path: Routes.connectionMeter.path,
                          name: Routes.connectionMeter.name,
                          redirect: (context, state) {
                            if (kIsWeb) {
                              return '/404';
                            }
                            return null;
                          },
                          builder: (context, state) {
                            final id = state.pathParameters['id'] ?? 'default';
                            final idMeter =
                                state.pathParameters['idMeter'] ?? 'default';
                            return ConnectionMeterPage(
                              id: id,
                              idMeter: idMeter,
                            );
                          },
                          routes: [
                            GoRoute(
                              parentNavigatorKey: rootNavigatorKey,
                              path: Routes.connectionMeterDevice.path,
                              name: Routes.connectionMeterDevice.name,
                              redirect: (context, state) {
                                if (kIsWeb) {
                                  return '/404';
                                }
                                return null;
                              },
                              builder: (context, state) {
                                final id =
                                    state.pathParameters['id'] ?? 'default';
                                final idMeter =
                                    state.pathParameters['idMeter'] ??
                                        'default';
                                return DeviceMeter(
                                  id: id,
                                  idMeter: idMeter,
                                );
                              },
                            ),
                          ]),
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
                          final id = state.pathParameters['id'] ?? 'default';
                          final idMeter =
                              state.pathParameters['idMeter'] ?? 'default';
                          return FormMeterPage(
                              idWorkspace: id, idMeter: idMeter);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'alerts',
                    name: Routes.alerts.name,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? 'default';
                      return AlertsPage(idWorkspace: id);
                    },
                    routes: [
                      GoRoute(
                        path: Routes.createAlerts.path,
                        name: Routes.createAlerts.name,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          final workspaceId =
                              state.pathParameters['id'] ?? 'default';
                          return FormAlertPage(
                            workspaceTitle: 'Alertas',
                            workspaceId: workspaceId,
                          );
                        },
                      ),
                      GoRoute(
                        path: Routes.updateAlerts.path,
                        name: Routes.updateAlerts.name,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          final workspaceId =
                              state.pathParameters['id'] ?? 'default';
                          final alert = state.extra as Alert?;
                          return FormAlertPage(
                            alert: alert,
                            workspaceTitle: 'Alertas',
                            workspaceId: workspaceId,
                          );
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
                    routes: [
                      GoRoute(
                        path: Routes.createGuest.path,
                        name: Routes.createGuest.name,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          final workspaceId =
                              state.pathParameters['id'] ?? 'default';
                          return FormInviteGuestPage(
                            workspaceId: workspaceId,
                            workspaceTitle: 'Invitados',
                          );
                        },
                      ),
                      GoRoute(
                        path: Routes.editGuest.path,
                        name: Routes.editGuest.name,
                        parentNavigatorKey: rootNavigatorKey,
                        builder: (context, state) {
                          final workspaceId =
                              state.pathParameters['id'] ?? 'default';
                          final guestId = state.pathParameters['guestId'] ?? '';

                          // Obtener el guest del provider
                          final guestProvider = Provider.of<GuestProvider>(
                              context,
                              listen: false);
                          final guest = guestProvider.guests.firstWhere(
                            (g) => g.id == guestId,
                            orElse: () => Guest(
                              id: guestId,
                              name: 'Cargando...',
                              email: '',
                              role: 'visitor',
                            ),
                          );

                          return FormInviteGuestPage(
                            workspaceId: workspaceId,
                            workspaceTitle: 'Invitados',
                            guest: guest.id == guestId ? guest : null,
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: Routes.locationMeters.path,
                    name: Routes.locationMeters.name,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? 'default';
                      return ViewMeterUbications(idWorkspace: id);
                    },
                  ),
                  GoRoute(
                    path: Routes.updateWorkspace.path,
                    name: Routes.updateWorkspace.name,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? 'default';
                      return FormWorkspacePage(idWorkspace: id);
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
    errorBuilder: (context, state) => ErrorPage(),
    redirect: _redirect,
  );
}
