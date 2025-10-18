import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend_water_quality/router/routes.dart';

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

  final String backendBaseUrl = "http://127.0.0.1:8000";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// 🔹 Inicia sesión con GitHub usando el navegador del sistema
  Future<void> _loginWithGitHub() async {
    final Uri githubLoginUrl = Uri.parse("$backendBaseUrl/auth/github/login");

    if (!await canLaunchUrl(githubLoginUrl)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir el navegador.")),
      );
      return;
    }

    // Abre el navegador
    await launchUrl(
      githubLoginUrl,
      mode: LaunchMode.externalApplication,
    );

    // 🚨 IMPORTANTE:
    // Tu backend debería redirigir al usuario a una página de éxito que indique
    // que ya puede volver a la app.
    // Si quieres manejar el token en Flutter, puedes hacerlo usando un endpoint
    // de confirmación, o detectando la sesión en tu backend.
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
            Image.asset('assets/images/logotipo_aquaminds.png', height: 150),
            Text('Bienvenido', style: Theme.of(context).textTheme.displayLarge),

            // --- Campo email ---
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                suffixIcon: Icon(Icons.email_outlined),
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

            // --- Campo contraseña ---
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: Icon(Icons.visibility_outlined),
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

            // --- Botón normal de inicio de sesión ---
            Center(
              child: ElevatedButton(
                onPressed: widget.isLoading
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
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Iniciar sesión'),
              ),
            ),

            // --- Botón de GitHub ---
            OutlinedButton.icon(
              icon: const Icon(Icons.code),
              label: const Text('Iniciar sesión con GitHub'),
              onPressed: widget.isLoading ? null : _loginWithGitHub,
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
              child: const Text('¿No tienes una cuenta? Regístrate'),
            ),
            TextButton(
              onPressed: () => context.goNamed(Routes.recoveryPassword.name),
              child: const Text('¿Olvidaste tu contraseña? Recuperarla'),
            ),
          ],
        ),
      ),
    );
  }
}
