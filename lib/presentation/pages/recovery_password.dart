import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/auth/form_recovery.dart';

class RecoveryPasswordPage extends StatelessWidget {
  final String title;

  const RecoveryPasswordPage({super.key, required this.title});

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
                child: const Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: RecoveryPasswordForm(),
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
