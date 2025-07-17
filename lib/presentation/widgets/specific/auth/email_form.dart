import 'package:flutter/material.dart';

class EmailForm extends StatelessWidget {
  final void Function(String email) onValid;

  EmailForm({super.key, required this.onValid});

  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final email = _controller.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      return;
    }

    onValid(email);
  }

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
          const Icon(Icons.lock_reset, size: 50),
          Text('Recuperar contraseña', style: textTheme.titleMedium),
          TextFormField(
            controller: _controller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            validator: (email) {
              if (email!.isEmpty || !email.contains('@')) {
                return "Correo inválido";
              }
              return null;
            },
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _submit();
                }
              },
              child: const Text('Enviar código'),
            ),
          ),
        ],
      ),
    );
  }
}
