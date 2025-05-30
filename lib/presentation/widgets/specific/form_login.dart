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
          const Center(
            child: Column(
              children: [
                Icon(Icons.image, size: 50),
                SizedBox(height: 12),
                Text(
                  'Logo y nombre',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'Bienvenido',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: emailController,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              labelText: 'Email address',
              labelStyle: TextStyle(fontSize: 18),
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: passwordController,
            obscureText: true,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(fontSize: 18),
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: Icon(Icons.visibility_outlined),
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3AE0D0),
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
