import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/form_register.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/auth/illustration_section.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  final String title;
  const RegisterPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: title,
      builder: (context, screenSize) {
        if (screenSize == ScreenSize.mobile) {
          return Padding(
            padding: EdgeInsets.all(24),
            child: _buildRegisterForm(),
          );
        } else {
          return Center(
            child: Container(
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
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: _buildRegisterForm(),
                    ),
                  ),
                  Expanded(child: IllustrationSection()),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildRegisterForm() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return RegisterForm(
          isLoading: authProvider.isLoading,
          errorMessage: authProvider.errorMessage ?? '',
          onRegister: (user) async => await _handleRegister(
            context,
            authProvider,
            user,
          ),
        );
      },
    );
  }

  Future<void> _handleRegister(
    BuildContext context,
    AuthProvider authProvider,
    User user,
  ) async {
    final success = await authProvider.register(user);
    if (success && context.mounted) {
      context.goNamed(Routes.login.name);
    }
  }
}
