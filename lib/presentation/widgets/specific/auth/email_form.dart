import 'package:flutter/material.dart';

class EmailForm extends StatefulWidget {
  final void Function(String email) onValid;

  const EmailForm({super.key, required this.onValid});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final email = _controller.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showSnackBar("Correo inválido");
      return;
    }

    // Simular envío de código
    widget.onValid(email);
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
              const Icon(Icons.lock_reset, size: 50),
              const SizedBox(height: 12),
              Text('Recuperar contraseña', style: textTheme.titleMedium),
            ],
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Correo electrónico'),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: _submit,
            child: const Text('Enviar código'),
          ),
        ),
      ],
    );
  }
}
