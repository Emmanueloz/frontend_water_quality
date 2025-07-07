import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends StatelessWidget {
  final bool isLoading;
  final String errorMessage;
  final Future<void> Function(User user)? onRegister;
  const RegisterForm({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    InputDecoration inputDecoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        suffixIcon: Icon(icon),
      );
    }

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Icon(Icons.person_add_alt, size: 50),
            Text(
              'Crear cuenta',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextFormField(
              controller: usernameController,
              keyboardType: TextInputType.text,
              decoration:
                  inputDecoration('Nombre de usuario', Icons.person_outline),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu nombre de usuario';
                } else if (value.length < 3) {
                  return 'El nombre de usuario debe tener al menos 3 caracteres';
                } else if (value.length > 20) {
                  return 'El nombre de usuario no puede tener más de 20 caracteres';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  inputDecoration('Correo electrónico', Icons.email_outlined),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu correo electrónico';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Por favor, ingresa un correo electrónico válido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: phoneController,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration: inputDecoration('Teléfono', Icons.phone_outlined),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Porfavor ingresa un numero de telefono';
                } else if (value.length != 10) {
                  return 'Porfavor ingresa un número de 10 digitos';
                }

                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: inputDecoration('Contraseña', Icons.lock_outline),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Porfavor ingresa una contraseña';
                } else if (value.length < 6) {
                  return 'La contraseña es muy corta';
                }
                return null;
              },
            ),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: inputDecoration(
                  'Confirmar contraseña', Icons.lock_reset_outlined),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Porfavor confirma tu contraseña';
                } else if (value != passwordController.text) {
                  return 'La contraseña no coincide';
                }
                return null;
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff145c57),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      if (formKey.currentState!.validate() &&
                          onRegister != null) {
                        final user = User(
                          username: usernameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        print(user.toJson());
                        //await onRegister!(user);
                      }
                    },
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Registrarse'),
            ),
            TextButton(
              onPressed: () => context.goNamed(Routes.login.name),
              child: const Text(
                '¿Ya tienes una cuenta? Inicia sesión',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
