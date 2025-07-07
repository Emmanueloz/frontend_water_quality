import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/auth/illustration_section.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_login.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final String title;
  const LoginPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: title,
      builder: (context, screenSize) {
        if (screenSize == ScreenSize.mobile) {
          // Solo formulario sin contenedor blanco ni sombra
          return Padding(
            padding: EdgeInsets.all(24),
            child: _buildLoginForm(context),
          );
        } else {
          // Desktop / pantallas grandes con ilustración y fondo blanco + sombra
          return Center(
            child: Container(
              width: 1000,
              height: 700,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: _buildLoginForm(context),
                    ),
                  ),
                  Expanded(
                    child: IllustrationSection(),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return LoginForm(
          isLoading: authProvider.isLoading,
          errorMessage: authProvider.errorMessage ?? '',
          onLogin: (email, password) async {
            await _handleLogin(context, authProvider, email, password);
          },
        );
      },
    );
  }

  Future<void> _handleLogin(BuildContext context, AuthProvider authProvider,
      String email, String password) async {
    final success = await authProvider.login(email, password);

    if (success && context.mounted) {
      context.goNamed(Routes.workspaces.name);
    }
  }
}
