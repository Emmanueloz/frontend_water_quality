// app_router.dart
import 'package:frontend_water_quality/presentation/pages/simple.dart';
import 'package:frontend_water_quality/presentation/pages/splash.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    //debugLogDiagnostics: true, // Útil durante el desarrollo
    //routerNeglect: true, // Ayuda con URLs en web
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => Splash(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const Simple(title: 'Login'),
      ),
      GoRoute(
        path: Routes.register,
        //name: 'register',
        builder: (context, state) => const Simple(title: 'Register'),
      ),
      GoRoute(
        path: Routes.listWorkspace,
        builder: (context, state) => const Simple(title: 'List Workspace'),
      ),
      GoRoute(
        path: Routes.viewWorkspace,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'default';
          return Simple(title: 'View Workspace $id');
        },
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const Simple(title: 'Profile'),
      ),
      GoRoute(
        path: Routes.alerts,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'default';
          return Simple(title: 'Alerts for Workspace $id');
        },
      ),
      GoRoute(
        path: Routes.listRecords,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'default';
          return Simple(title: 'Records for Workspace $id');
        },
      ),
      GoRoute(
        path: Routes.notificationDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'default';
          return Simple(title: 'Notification Details $id');
        },
      ),
    ],
  );
}
