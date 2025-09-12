import 'package:flutter/material.dart';
import 'package:frontend_water_quality/infrastructure/connectivity_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/button_profile.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppBarNavigation extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarNavigation({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ConnectivityProvider, AuthProvider>(
      builder: (context, connectivityProvider, authProvider, child) {
        List<Widget> actions = [];

        final bool isOffline = connectivityProvider.isOffline;

        if (isOffline) {
          actions = [
            IconButton(
              icon: Icon(Icons.wifi_off),
              onPressed: () {},
            ),
          ];
        }

        if (authProvider.isAuthenticated) {
          actions = [
            ...actions,
            TextButton(
              child: const Text("Espacios de trabajo"),
              onPressed: () {
                if (isOffline) {
                  return;
                }
                context.goNamed(Routes.workspaces.name);
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                if (isOffline) {
                  return;
                }
                context.goNamed(Routes.listNotifications.name);
              },
            ),
            ButtonProfile(
              username: authProvider.user?.username ?? "",
              email: authProvider.user?.email ?? "",
              onPressed: () {
                if (isOffline) {
                  return;
                }
                context.goNamed(Routes.profile.name);
              },
            ),
            IconButton(
              onPressed: () {
                if (isOffline) {
                  return;
                }
                authProvider.logout();
                context.goNamed(Routes.login.name);
              },
              icon: Icon(
                Icons.logout,
              ),
            ),
            SizedBox(
              width: 10,
            )
          ];
        } else {
          actions = [
            ...actions,
            TextButton(
              child: const Text("Inicio de sesion"),
              onPressed: () {
                context.goNamed(Routes.login.name);
              },
            ),
            TextButton(
              child: const Text("Registro"),
              onPressed: () {
                context.goNamed(Routes.register.name);
              },
            )
          ];
        }

        return AppBar(
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () => {context.goNamed(Routes.splash.name)},
          ),
          title: Text(title),
          actions: actions,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
