import 'package:flutter/material.dart';

class CodeForm extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final void Function(String code) onValid;

  CodeForm({
    super.key,
    required this.onValid,
    required this.isLoading,
    this.errorMessage,
  });

  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final code = _controller.text.trim();

    onValid(code);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          const Icon(Icons.lock_reset, size: 50),
          Text(
            'Verificar codigo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Código de verificación'),
            validator: (value) {
              if (value!.length != 6 || int.tryParse(value) == null) {
                return "El código debe tener 6 dígitos numéricos";
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
              child: const Text('Verificar'),
            ),
          ),
        ],
      ),
    );
  }
}
