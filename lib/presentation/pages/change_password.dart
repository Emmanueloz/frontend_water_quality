import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_change.dart';
import 'package:frontend_water_quality/router/routes.dart';

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
      builder: (context, screenSize) => Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
              maxHeight: 500,
            ),
            child: ChangePasswordForm(
              email: email,
              onSubmit: (newPassword) {
                context.goNamed(Routes.login.name);
              },
            ),
          ),
        ),
      ),
    );
  }
}
