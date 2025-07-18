import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_change.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatelessWidget {
  final String token;

  const ChangePasswordPage({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Cambiar contraseña",
      builder: (context, screenSize) => Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
              maxHeight: 500,
            ),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return ChangePasswordForm(
                  isLoading: authProvider.isLoading,
                  email: authProvider.emailRecovery,
                  errorMessage: authProvider.errorMessage,
                  onSubmit: (newPassword) async {
                    final result =
                        await authProvider.resetPassword(token, newPassword);
                    if (result && context.mounted) {
                      context.goNamed(Routes.login.name);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
