import 'package:flutter/material.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/go_to_button.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    InputDecoration inputDecoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18),
        suffixIcon: Icon(icon),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Color(0xff5accc4)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Color(0xff5accc4)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Color(0xff5accc4), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Column(
              children: [
                Icon(Icons.person_add_alt, size: 50),
                SizedBox(height: 12),
                Text(
                  'Crear cuenta',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: usernameController,
            style: const TextStyle(fontSize: 18),
            decoration:
                inputDecoration('Nombre de usuario', Icons.person_outline),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 18),
            decoration:
                inputDecoration('Correo electrónico', Icons.email_outlined),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 18),
            decoration: inputDecoration('Teléfono', Icons.phone_outlined),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: passwordController,
            obscureText: true,
            style: const TextStyle(fontSize: 18),
            decoration: inputDecoration('Contraseña', Icons.lock_outline),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            style: const TextStyle(fontSize: 18),
            decoration: inputDecoration(
                'Confirmar contraseña', Icons.lock_reset_outlined),
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff145c57),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    final username = usernameController.text.trim();
                    final email = emailController.text.trim();
                    final phone = phoneController.text.trim();
                    final password = passwordController.text.trim();
                    final confirmPassword =
                        confirmPasswordController.text.trim();

                    if (username.isEmpty ||
                        email.isEmpty ||
                        phone.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Todos los campos son obligatorios')),
                      );
                      return;
                    }

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Las contraseñas no coinciden')),
                      );
                      return;
                    }

                    context.go(Routes.listWorkspace.path);
                  },
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 12),
                const GoToButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
