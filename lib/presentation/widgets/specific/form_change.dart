import 'package:flutter/material.dart';

class ChangePasswordForm extends StatefulWidget {
  final void Function(String password) onSubmit;

  const ChangePasswordForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (password.length < 6) {
      _showSnackBar('Debe tener al menos 6 caracteres');
      return;
    }

    if (password != confirm) {
      _showSnackBar('Las contraseñas no coinciden');
      return;
    }

    widget.onSubmit(password);
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              const Icon(Icons.lock, size: 50),
              const SizedBox(height: 12),
              Text(
                'Cambio de contraseña',
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const SizedBox(height: 30),
        TextField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Nueva contraseña',
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirmar contraseña',
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: ElevatedButton(
            onPressed: _submit,
            child: const Text('Actualizar contraseña'),
          ),
        ),
      ],
    );
  }
}
