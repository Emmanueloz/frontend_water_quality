import 'package:flutter/material.dart';

enum FieldType {
  name,
  email,
  phone,
  password,
  confirmPassword,
  generic,
}

class ProfileInfoField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final FieldType fieldType;
  final TextEditingController? passwordController; // para confirmación

  const ProfileInfoField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.fieldType = FieldType.generic,
    this.passwordController,
  });

  String? _validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo no puede estar vacío';
    }

    switch (fieldType) {
      case FieldType.name:
        final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
        if (!nameRegex.hasMatch(value.trim())) {
          return 'El nombre solo puede contener letras y espacios';
        }
        if (value.trim().length < 3) {
          return 'El nombre debe tener al menos 3 caracteres';
        }
        break;

      case FieldType.email:
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Ingrese un correo válido';
        }
        break;

      case FieldType.phone:
        final phoneRegex = RegExp(r'^\+?[0-9]{12}$');
        if (!phoneRegex.hasMatch(value.trim())) {
          return 'Ingrese un teléfono válido (solo números, 10 dígitos)';
        }
        break;

      case FieldType.password:
        if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
        break;

      case FieldType.confirmPassword:
        if (passwordController != null && value != passwordController!.text) {
          return 'Las contraseñas no coinciden';
        }
        break;

      case FieldType.generic:
        // solo no vacío
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
      ),
      validator: _validator,
    );
  }
}
