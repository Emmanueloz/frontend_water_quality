import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
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
                    Expanded(child: _IllustrationSection()),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: const LoginForm(),
                      ),
                    ),
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

class _IllustrationSection extends StatelessWidget {
  final bool isMobile;
  const _IllustrationSection({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMobile ? 16 : 16),
          bottomLeft: Radius.circular(isMobile ? 0 : 16),
          topRight: Radius.circular(isMobile ? 16 : 0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('../../../assets/images/agua.png',
              width: 500, height: 500),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
