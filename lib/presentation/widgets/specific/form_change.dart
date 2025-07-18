import 'package:flutter/material.dart';

class ChangePasswordForm extends StatelessWidget {
  final bool isLoading;
  final String? email;
  final String? errorMessage;
  final void Function(String password) onSubmit;

  ChangePasswordForm({
    super.key,
    required this.onSubmit,
    required this.isLoading,
    this.errorMessage,
    this.email,
  });

  final _newPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          const Icon(Icons.lock, size: 50),
          Text(
            'Cambio de contraseña',
            style: textTheme.titleMedium,
          ),
          if (email != null)
            Text(
              'Correo: $email',
              style: textTheme.bodyMedium,
            ),
          TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Nueva contraseña',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa una contraseña';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirmar contraseña',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor confirma tu contraseña';
              }
              if (value != _newPasswordController.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
          ),
          if (errorMessage != null)
            Text(
              errorMessage ?? "",
              style: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  onSubmit(_newPasswordController.text);
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Cambiar contraseña'),
            ),
          ),
        ],
      ),
    );
  }
}
