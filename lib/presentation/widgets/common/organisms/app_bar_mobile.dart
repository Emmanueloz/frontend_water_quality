import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/theme_toggle_button.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppBarMobile extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarMobile({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    List<Widget> actions = [];

    if (!authProvider.isAuthenticated) {
      actions = [
        TextButton(
          child: const Text("Iniciar sesión"),
          onPressed: () {
            context.goNamed(Routes.login.name);
          },
        ),
        SizedBox(width: 7),
        ThemeToggleButton(),
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
