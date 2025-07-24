import 'package:flutter/material.dart';

class EmailForm extends StatefulWidget {
  final bool isLoading;
  final String? errorMessage;
  final void Function(String email) onValid;

  const EmailForm({
    super.key,
    required this.onValid,
    required this.isLoading,
    this.errorMessage,
  });

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _controller.text.trim();
    widget.onValid(email);
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
            const Icon(Icons.lock_reset, size: 50),
            Text('Recuperar contraseña', style: textTheme.titleMedium),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(labelText: 'Correo electrónico'),
              validator: (email) {
                if (email!.isEmpty || !email.contains('@')) {
                  return "Correo inválido";
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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _submit();
                  }
                },
                child: widget.isLoading
                    ? CircularProgressIndicator()
                    : const Text('Enviar código'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
