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
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Clave generada', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            SizedBox(
              width: 200,
              child: SelectableText(
                password,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
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
        ),
      ),
    );
  }
}
