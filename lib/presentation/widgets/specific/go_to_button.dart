import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_water_quality/router/routes.dart';

class GoToButton extends StatelessWidget {
  const GoToButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => context.go(Routes.login.path),
        child: const Text(
          'Regresar a Inicio de sesión',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
