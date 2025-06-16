import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_recovery.dart';

class RecoveryPasswordPage extends StatelessWidget {
  final String title;

  const RecoveryPasswordPage({
    super.key,
    required this.title,
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
              return const Padding(
                padding: EdgeInsets.all(24),
                child: RecoveryPasswordForm(),
              );
            } else {
              return Container(
                width: 600,
                height: 400,
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
                child: const RecoveryPasswordForm(),
              );
            }
          },
        ),
      ),
    );
  }
}
