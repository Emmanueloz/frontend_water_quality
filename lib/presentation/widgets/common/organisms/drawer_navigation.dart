import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/theme_toggle_switch.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DrawerNavigation extends StatelessWidget {
  final String title;
  final List<Widget>? children;
  const DrawerNavigation({
    super.key,
    required this.title,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                width: 0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authProvider.user?.username ?? ""),
                    Text(
                      authProvider.user?.email ?? "",
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                    Chip(
                      label: Text(
                        authProvider.user?.rol?.name ?? "",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              "Paginas",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: const Text(
              "Espacios de trabajo",
            ),
            onTap: () {
              context.goNamed(Routes.workspaces.name, queryParameters: {
                "type": ListWorkspaces.mine.name,
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: const Text(
              "Notificaciones",
            ),
            onTap: () {
              context.goNamed(Routes.listNotifications.name);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: const Text(
              "Perfil",
            ),
            onTap: () {
              context.goNamed(Routes.profile.name);
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerLeft,
            child: ThemeToggleSwitch(),
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            thickness: 0.5,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text(
              "Cerrar sesión",
            ),
            onTap: () {
              authProvider.logout();
              context.goNamed(Routes.login.name);
            },
          ),
        ],
      ),
    );
  }
}
