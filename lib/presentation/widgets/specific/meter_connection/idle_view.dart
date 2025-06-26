import 'package:flutter/material.dart';

class IdleView extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onStart;

  const IdleView({
    super.key,
    required this.isLoading,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Conectar dispositivo IoT',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text('Presiona el botón para generar la clave de conexión.',
            textAlign: TextAlign.center),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : onStart,
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Iniciar conexión'),
        ),
      ],
    );
  }
}