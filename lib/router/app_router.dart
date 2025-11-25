// app_router.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';
import 'package:frontend_water_quality/presentation/pages/alerts.dart';
import 'package:frontend_water_quality/presentation/pages/analysis/analysis.dart';
import 'package:frontend_water_quality/presentation/pages/analysis/average_page.dart';
import 'package:frontend_water_quality/presentation/pages/analysis/average_period_page.dart';
import 'package:frontend_water_quality/presentation/pages/analysis/correlation_page.dart';
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
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/core/enums/roles.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_meters.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_workspace.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/workspace_context.dart';
import 'package:frontend_water_quality/presentation/pages/weather_page.dart';
import 'package:frontend_water_quality/router/routes.dart';
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

    if (state.uri.path == Routes.aboutUs.path) {
      return null;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // 1) Capturar token/usuario desde cualquier ruta (query o fragment) para
    // completar el login aunque el backend no redirija exactamente a /#/auth/callback
    try {
      // Intento por query
      String? token = state.uri.queryParameters['token'];
      String? email = state.uri.queryParameters['email'];
      String? username = state.uri.queryParameters['username'];
      String? uid = state.uri.queryParameters['uid'];
      String? rolStr = state.uri.queryParameters['rol'];

      // Intento adicional por fragment (hash) en Web
      if ((token == null || token.isEmpty) && kIsWeb) {
        final fragment = Uri.base.fragment; // ej: "/auth/callback?token=..."
        if (fragment.isNotEmpty) {
          final hasQuery = fragment.contains('?');
          final query = hasQuery ? fragment.split('?').last : '';
          if (query.isNotEmpty) {
            final params = Uri.splitQueryString(query);
            token = params['token'] ?? token;
            email = params['email'] ?? email;
            username = params['username'] ?? username;
            uid = params['uid'] ?? uid;
            rolStr = params['rol'] ?? rolStr;
          }
        }
      }

      if (!authProvider.isAuthenticated && token != null && token.isNotEmpty) {
        bool ok = false;
        if (email != null && email.isNotEmpty) {
          String normalizeRole(String? value) {
            if (value == null || value.isEmpty) return 'unknown';
            final raw = value.contains('.') ? value.split('.').last : value;
            return raw.toLowerCase();
          }

          final normalized = normalizeRole(rolStr);
          final role = AppRoles.values.firstWhere(
            (e) => e.name == normalized,
            orElse: () => AppRoles.unknown,
          );

          final user = User(
            uid: uid,
            email: email,
            username: username,
            phone: null,
            rol: role,
          );

          ok = await authProvider.loginWithTokenAndUser(token, user);
        } else {
          ok = await authProvider.loginWithToken(token);
        }

        if (ok) {
          return Routes.workspaces.path;
        }
      }
    } catch (_) {
      // Si algo falla en la lectura del fragment/query, continuamos con el flujo normal
    }

    // Evitar rebotes mientras se está autenticando (previene ir a /login por carrera)
    if (authProvider.isLoading) {
      return null;
    }
    final List<String> publicRoutes = [
      Routes.splash.path,
      Routes.login.path,
      Routes.register.path,
      Routes.recoveryPassword.path,
      Routes.changePassword.path,
      Routes.authCallback.path,
    ];


    final isOnPublicRoute = publicRoutes.contains(state.uri.path); 

    authProvider.cleanError();

    if (!authProvider.isAuthenticated && !isOnPublicRoute) {
      // Si hay token en storage pero el provider aún no se marca auth, evita mandar a login
      final storedToken = await LocalStorageService.get(StorageKey.token);
      if (storedToken != null && storedToken.isNotEmpty) {
        return null;
      }
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
                builder: (context, screenSize, workspace) => WorkspaceContext(
                  workspace: workspace,
                  child: child,
                ),
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
                            builder: (context, state) => CorrelationPage(
                              idWorkspace:
                                  state.pathParameters['id'] ?? 'default',
                              idMeter:
                                  state.pathParameters['idMeter'] ?? 'default',
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
        path: Routes.listNotifications.path,
        name: Routes.listNotifications.name,
        builder: (context, state) => const ViewListNotifications(),
        routes: [
          GoRoute(
            path: Routes.notificationDetails.path,
            name: Routes.notificationDetails.name,
            builder: (context, state) {
              final notificationId = state.pathParameters['id'];

              if (notificationId == null || notificationId.isEmpty) {
                // Si no hay ID, redirigir a la lista
                Future.microtask(
                    () => context.goNamed(Routes.listNotifications.name));
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return NotificationDetailPage(
                notificationId: notificationId,
              );
            },
          ),
        ],
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
          final token = state.uri.queryParameters['temporaryToken'];

          return ChangePasswordPage(
            token: token,
          );
        },
      ),
      GoRoute(
        path: Routes.authCallback.path,
        name: Routes.authCallback.name,
        builder: (context, state) {
          // Intento 1: Path URL Strategy (state.uri)
          String? token = state.uri.queryParameters['token'];
          String? email = state.uri.queryParameters['email'];
          String? username = state.uri.queryParameters['username'];
          String? uid = state.uri.queryParameters['uid'];
          String? rolStr = state.uri.queryParameters['rol'];

          // Intento 2: Hash URL Strategy (fragmento de Uri.base)
          if ((token == null || token.isEmpty) && kIsWeb) {
            final fragment =
                Uri.base.fragment; // ej: "/oauth/callback?token=...&email=..."
            if (fragment.isNotEmpty) {
              final hasQuery = fragment.contains('?');
              final query = hasQuery ? fragment.split('?').last : '';
              if (query.isNotEmpty) {
                final params = Uri.splitQueryString(query);
                token = params['token'] ?? token;
                email = params['email'] ?? email;
                username = params['username'] ?? username;
                uid = params['uid'] ?? uid;
                rolStr = params['rol'] ?? rolStr;
              }
            }
          }

          // Ejecutar login con token (y usuario si viene) y redirigir
          Future.microtask(() async {
            if (token != null && token.isNotEmpty) {
              final auth = Provider.of<AuthProvider>(context, listen: false);

              bool ok = false;
              if (email != null && email.isNotEmpty) {
                String normalizeRole(String? value) {
                  if (value == null || value.isEmpty) return 'unknown';
                  final raw =
                      value.contains('.') ? value.split('.').last : value;
                  return raw.toLowerCase();
                }

                final normalized = normalizeRole(rolStr);
                final role = AppRoles.values.firstWhere(
                  (e) => e.name == normalized,
                  orElse: () => AppRoles.unknown,
                );

                final user = User(
                  uid: uid,
                  email: email,
                  username: username,
                  phone: null, // backend aún no envía phone
                  rol: role,
                );

                ok = await auth.loginWithTokenAndUser(token, user);
              } else {
                ok = await auth.loginWithToken(token);
              }

              if (ok && context.mounted) {
                context.goNamed(Routes.workspaces.name);
              } else if (context.mounted) {
                context.goNamed(Routes.login.name);
              }
            } else if (context.mounted) {
              context.goNamed(Routes.login.name);
            }
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      )
    ],
    errorBuilder: (context, state) => ErrorPage(),
    redirect: _redirect,
  );
}
