import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_change.dart';

class ChangePasswordPage extends StatelessWidget {
  final String title;
  final String email;
  final String token;

  const ChangePasswordPage({
    super.key,
    required this.title,
    required this.email,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: title,
      builder: (context, screenSize) => Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            if (isMobile) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: ChangePasswordForm(email: email),
              );
            } else {
              return Container(
                width: 600,
                height: 500,
                margin: const EdgeInsets.all(16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
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
                child: ChangePasswordForm(email: email),
              );
            }
          },
        ),
      ),
    );
  }
}
