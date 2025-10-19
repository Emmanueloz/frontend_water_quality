import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

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
  bool _isLaunchingOAuth = false;

  final String backendBaseUrl = "https://aqua-minds.org";
  static const MethodChannel _deeplinkChannel =
      MethodChannel('aquaminds/deeplink');

  String get _apiBase {
    return backendBaseUrl;
  }

  @override
  void initState() {
    super.initState();
    _deeplinkChannel.setMethodCallHandler((call) async {
      if (!mounted) return null;
      if (call.method == 'onDeepLink') {
        final String? uriString = call.arguments as String?;
        if (uriString != null) {
          _handleDeepLink(uriString);
        }
      }
      return null;
    });
    _checkInitialLink();
  }

  Future<void> _checkInitialLink() async {
    try {
      final String? initial =
          await _deeplinkChannel.invokeMethod<String>('getInitialLink');
      if (initial != null) {
        _handleDeepLink(initial);
      }
    } catch (_) {}
  }

  void _handleDeepLink(String uriString) async {
    final uri = Uri.tryParse(uriString);
    if (uri == null) return;
    final token = uri.queryParameters['token'] ?? uri.queryParameters['code'];
    if (token != null) {
      debugPrint('DeepLink recibido: $uriString');
      debugPrint('Token/Code: $token');
      if (!mounted) return;

      try {
        // Resetear bandera para permitir futuros intentos si el usuario cierra sesión
        if (mounted && _isLaunchingOAuth) {
          setState(() => _isLaunchingOAuth = false);
        }
        // TODO: Implementar la lógica para validar el token y obtener los datos del usuario
        // Ejemplo:
        // final authProvider = Provider.of<AuthProvider>(context, listen: false);
        // final success = await authProvider.loginWithGitHub(token);

        // if (success) {
        //   context.goNamed(Routes.workspaces.name);
        // } else {
        //   throw Exception('No se pudo autenticar con GitHub');
        // }
        final auth = context.read<AuthProvider>();
        final success = await auth.loginWithToken(token);
        if (success) {
          if (!mounted) return;
          context.goNamed(Routes.workspaces.name);
          return;
        }
        throw Exception('No se pudo autenticar con GitHub');
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Error al procesar el token de GitHub: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
        if (mounted && _isLaunchingOAuth) {
          setState(() => _isLaunchingOAuth = false);
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// 🔹 Inicia sesión con GitHub usando el navegador del sistema
  Future<void> _loginWithGitHub() async {
    if (_isLaunchingOAuth) return;
    final Uri url = kIsWeb
        ? Uri.parse("$_apiBase/auth/github/login")
        : Uri.parse("$_apiBase/auth/github/login/mobile");

    debugPrint('Abriendo login OAuth en: $url');

    if (!await canLaunchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir el navegador.")),
      );
      return;
    }

    setState(() => _isLaunchingOAuth = true);
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
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
