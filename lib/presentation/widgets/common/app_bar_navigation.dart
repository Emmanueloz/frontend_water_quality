import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/common/button_profile.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class AppBarNavigation extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarNavigation({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        TextButton(
          child: const Text("Espacios de trabajo"),
          onPressed: () {
            context.goNamed(Routes.workspaces.name);
          },
        ),
        IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.goNamed(Routes.listNotifications.name);
            }),
        ButtonProfile(
          username: "Username",
          email: "email@email.com",
          onPressed: () {
            context.goNamed(Routes.profile.name);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
