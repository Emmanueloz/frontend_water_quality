import 'package:flutter/material.dart';

class ChangePasswordForm extends StatefulWidget {
  final String email;

  const ChangePasswordForm({
    super.key,
    required this.email,
  });

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (newPass != confirmPass) {
      _showSnackBar("Las contraseñas no coinciden");
      return;
    }

    if (newPass.length < 6) {
      _showSnackBar("La contraseña debe tener al menos 6 caracteres");
      return;
    }

    _showSnackBar("Contraseña actualizada (simulada)");
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Column(
              children: [
                Icon(Icons.lock_reset_outlined, size: 50),
                SizedBox(height: 12),
                Text(
                  'Cambio de contraseña',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              'Usuario: ${widget.email}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            style: const TextStyle(fontSize: 18),
            decoration: _inputDecoration('Nueva contraseña'),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            style: const TextStyle(fontSize: 18),
            decoration: _inputDecoration('Confirmar contraseña'),
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
              onPressed: _handleSubmit,
              child: const Text(
                'Actualizar contraseña',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 18),
      suffixIcon: const Icon(Icons.visibility_outlined),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    );
  }
}
