import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_mobile_field/country_picker_dialog.dart';
import 'package:intl_mobile_field/intl_mobile_field.dart';
import 'package:intl_mobile_field/mobile_number.dart';

class RegisterForm extends StatefulWidget {
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
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    MobileNumber? number;

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
            IntlMobileField(
              languageCode: "mx",
              controller: phoneController,
              pickerDialogStyle: PickerDialogStyle(
                width: 600,
                searchFieldInputDecoration: InputDecoration(
                  label: Text("Buscar Pais"),
                ),
              ),
              initialCountryCode: "MX",
              invalidNumberMessage: "Numero de telefono invalido",
              decoration: inputDecoration("Telefono", Icons.phone),
              validator: (value) {
                if (value == null || value.number.isEmpty) {
                  return 'Por favor, introduzca un número de móvil';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value.number)) {
                  return 'Solo se permiten dígitos';
                }
                return null;
              },
              onChanged: (value) {
                number = value;
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
              onPressed: widget.isLoading
                  ? null
                  : () async {
                      print(number);
                      if (formKey.currentState!.validate() &&
                          widget.onRegister != null) {
                        final user = User(
                          username: usernameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: "${number?.countryCode}${number?.number}",
                          password: passwordController.text.trim(),
                        );
                        print(user.toJson());
                        await widget.onRegister!(user);
                      }
                    },
              child: widget.isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Registrarse'),
            ),
            if (widget.errorMessage.isNotEmpty)
              Center(
                child: Text(
                  widget.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
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
