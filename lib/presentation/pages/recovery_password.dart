import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/auth/email_form.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/auth/code_form.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class RecoveryPasswordPage extends StatefulWidget {
  const RecoveryPasswordPage({super.key});

  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  bool showCodeForm = false;
  String email = '';

  void handleEmailValid(String value) {
    setState(() {
      email = value;
      showCodeForm = true;
    });
  }

  void handleCodeValid(String code) {
    context.goNamed(Routes.changePassword.name, extra: {
      'email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Recuperar contraseña",
      builder: (context, screenSize) => Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
            child: showCodeForm
                ? CodeForm(onValid: handleCodeValid)
                : EmailForm(onValid: handleEmailValid),
          ),
        ),
      ),
    );
  }
}
