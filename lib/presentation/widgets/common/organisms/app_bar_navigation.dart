import 'package:flutter/material.dart';
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    List<Widget> actions = [];

    if (authProvider.isAuthenticated) {
      print(authProvider.user);

      actions = [
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
          username: authProvider.user?.username ?? "",
          email: authProvider.user?.email ?? "",
          onPressed: () {
            context.goNamed(Routes.profile.name);
          },
        ),
        IconButton(
          onPressed: () {
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
    }

    return AppBar(
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
