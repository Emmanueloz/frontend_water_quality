import 'package:flutter/material.dart';

class EmailForm extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final void Function(String email) onValid;

  EmailForm({
    super.key,
    required this.onValid,
    required this.isLoading,
    this.errorMessage,
  });

  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final email = _controller.text.trim();
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
                  _submit();
                }
              },
              child: isLoading
                  ? CircularProgressIndicator()
                  : const Text('Enviar código'),
            ),
          ),
        ],
      ),
    );
  }
}
