import 'package:flutter/material.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Icon(Icons.image, size: 50),
                SizedBox(height: 12),
                Text(
                  'Logo y nombre',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              'Bienvenido',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: emailController,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              suffixIcon: const Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: passwordController,
            obscureText: true,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              labelText: 'Contraseña',
              suffixIcon: const Icon(Icons.visibility_outlined),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff145c57),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.go(Routes.listWorkspace.path);
              },
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
