import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/auth/email_form.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/auth/code_form.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecoveryPasswordPage extends StatefulWidget {
  const RecoveryPasswordPage({super.key});

  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  bool showCodeForm = false;

  void nextPage(String token) {
    context.goNamed(Routes.changePassword.name, queryParameters: {
      'token': token,
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
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return showCodeForm
                    ? CodeForm(
                        onValid: (code) async {
                          print(code);
                          final token =
                              await authProvider.verifyResetCode(code);
                          if (token != null) {
                            nextPage(token);
                          }
                        },
                        isLoading: authProvider.isLoading,
                        errorMessage: authProvider.errorMessage,
                      )
                    : EmailForm(
                        onValid: (email) async {
                          print(email);
                          if (await authProvider.requestPasswordReset(email)) {
                            setState(() {
                              showCodeForm = true;
                            });
                          }
                        },
                        isLoading: authProvider.isLoading,
                        errorMessage: authProvider.errorMessage,
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
