import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_change.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatelessWidget {
  final String title;
  final String email;

  const ChangePasswordPage({
    super.key,
    required this.title,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: title,
      builder: (context, screenSize) => Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 600,
                  maxHeight: 500,
                ),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: ChangePasswordForm(
                      email: email,
                      onSubmit: (newPassword) {
                        // Simulación de cambio de contraseña
                        context.goNamed('login');
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
