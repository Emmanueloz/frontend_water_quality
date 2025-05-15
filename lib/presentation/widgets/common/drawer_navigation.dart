import 'package:flutter/material.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class DrawerNavigation extends StatelessWidget {
  final String title;
  const DrawerNavigation({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlueAccent),
            child: Text(
              title,
              style: TextStyle(fontSize: 24),
            ),
          ),
          ListTile(
            title: const Text(
              "Workspaces",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              context.goNamed(Routes.listWorkspace.name);
            },
          ),
        ],
      ),
    );
  }
}
