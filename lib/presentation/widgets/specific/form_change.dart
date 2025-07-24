import 'package:flutter/material.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordForm extends StatefulWidget {
  final bool isLoading;
  final String? email;
  final String? errorMessage;
  final void Function(String password) onSubmit;

  const ChangePasswordForm({
    super.key,
    required this.onSubmit,
    required this.isLoading,
    this.errorMessage,
    this.email,
  });

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final formKey = GlobalKey<FormState>();

  final _newPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Form(
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
            if (widget.email != null)
              Text(
                'Correo: ${widget.email}',
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
            if (widget.errorMessage != null)
              Text(
                widget.errorMessage ?? "",
                style: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  widget.onSubmit(_newPasswordController.text);
                }
              },
              child: widget.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Cambiar contraseña'),
            ),
            TextButton(
              onPressed: () {
                context.goNamed(Routes.login.name);
              },
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
