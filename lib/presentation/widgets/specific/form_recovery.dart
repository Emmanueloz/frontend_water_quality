import 'package:flutter/material.dart';

class RecoveryPasswordForm extends StatefulWidget {
  const RecoveryPasswordForm({super.key});

  @override
  State<RecoveryPasswordForm> createState() => _RecoveryPasswordFormState();
}

class _RecoveryPasswordFormState extends State<RecoveryPasswordForm> {
  final TextEditingController emailController = TextEditingController();

  void _handleSubmit() {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showSnackBar("Por favor ingresa un correo válido");
      return;
    }

    // Simulación de envío
    _showSnackBar("Correo de recuperación enviado (simulado)");
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
                Icon(Icons.mail_outline, size: 50),
                SizedBox(height: 12),
                Text(
                  'Recuperar contraseña',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: emailController,
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('Correo electrónico'),
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
                'Enviar enlace',
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
      suffixIcon: const Icon(Icons.email_outlined),
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
