import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('error'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error, size: 48, color: Colors.red),
        const SizedBox(height: 8),
        Text('Ocurrió un error',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    );
  }
}