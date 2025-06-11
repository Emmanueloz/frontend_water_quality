import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/auth/illustration_section.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_login.dart';

class LoginPage extends StatelessWidget {
  final String title;
  const LoginPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: title,
      builder: (context, screenSize) => Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            if (isMobile) {
              // Solo formulario sin contenedor blanco ni sombra
              return const Padding(
                padding: EdgeInsets.all(24),
                child: LoginForm(),
              );
            } else {
              // Desktop / pantallas grandes con ilustración y fondo blanco + sombra
              return Container(
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
                        child: const LoginForm(),
                      ),
                    ),
                    Expanded(
                      child: IllustrationSection(),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
