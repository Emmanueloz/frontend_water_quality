import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                width: 0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: Text(
              title,
              style: TextStyle(fontSize: 24),
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
            title: const Text(
              "Perfil",
            ),
            onTap: () {
              context.goNamed(Routes.profile.name);
            },
          ),
          if (children != null)
            ListTile(
              title: Text(
                "Secciones",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ...?children,
          ListTile(
            title: const Text(
              "Notificaciones",
            ),
            onTap: () {
              context.goNamed(Routes.listNotifications.name);
            },
          ),
        ],
      ),
    );
  }
}
