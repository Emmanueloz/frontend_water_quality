import 'package:flutter/material.dart';

class PasswordView extends StatelessWidget {
  final String password;
  final bool isLoading;
  final VoidCallback onContinue;

  const PasswordView({
    super.key,
    required this.password,
    required this.isLoading,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Clave generada',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(
          width: 200,
          child: TextField(
            readOnly: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Monospace', fontSize: 20),
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              hintText: password,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Ingresa esta clave en tu dispositivo.',
            textAlign: TextAlign.center),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : onContinue,
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('He ingresado la clave'),
        ),
      ],
    );
  }
}
