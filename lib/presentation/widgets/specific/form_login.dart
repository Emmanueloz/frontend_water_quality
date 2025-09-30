import 'package:flutter/material.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  final bool isLoading;
  final String errorMessage;
  final Future<void> Function(String email, String password)? onLogin;

  const LoginForm({
    super.key,
    this.onLogin,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Image.asset('assets/images/logotipo_aquaminds.png',
                height: 150),
            Text(
              'Bienvenido',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                suffixIcon: const Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu correo electrónico';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Por favor, ingresa un correo electrónico válido';
                }

                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: const Icon(Icons.visibility_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu contraseña';
                } else if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: widget.isLoading == true
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          if (widget.onLogin != null) {
                            await widget.onLogin!(
                              emailController.text,
                              passwordController.text,
                            );
                          }
                        }
                      },
                child: widget.isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Iniciar sesión'),
              ),
            ),
            if (widget.errorMessage.isNotEmpty)
              Center(
                child: Text(
                  widget.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () => context.goNamed(Routes.register.name),
              child: const Text(
                '¿No tienes una cuenta? Regístrate',
              ),
            ),
            TextButton(
              onPressed: () => context.goNamed(Routes.recoveryPassword.name),
              child: const Text(
                '¿Olvidaste tu contraseña? Recuperarla',
              ),
            )
          ],
        ),
      ),
    );
  }
}
