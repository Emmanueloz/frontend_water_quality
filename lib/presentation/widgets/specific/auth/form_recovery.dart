import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecoveryPasswordForm extends StatefulWidget {
  const RecoveryPasswordForm({super.key});

  @override
  State<RecoveryPasswordForm> createState() => _RecoveryPasswordFormState();
}

class _RecoveryPasswordFormState extends State<RecoveryPasswordForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  bool showCodeForm = false;

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }

  void _onEmailSubmitted() {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showSnackBar("Correo inválido");
      return;
    }

    // Aquí iría el llamado real al backend para enviar el correo
    setState(() {
      showCodeForm = true;
    });
  }

  void _onCodeSubmitted() {
    final code = codeController.text.trim();
    if (code.length != 6 || int.tryParse(code) == null) {
      _showSnackBar("El código debe ser un número de 6 dígitos");
      return;
    }

    // Aquí iría la validación del código en backend si fuera real
    context.goNamed('change-password', extra: {
      'email': emailController.text.trim(),
    });
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
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
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              const Icon(Icons.lock_reset, size: 50),
              const SizedBox(height: 12),
              Text(
                'Recuperar contraseña',
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        if (!showCodeForm)
          Column(
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Correo electrónico'),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _onEmailSubmitted,
                  child: const Text('Enviar código'),
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Código de verificación'),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _onCodeSubmitted,
                  child: const Text('Verificar'),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
