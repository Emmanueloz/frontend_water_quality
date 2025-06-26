import 'package:flutter/material.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.check_circle, size: 48, color: Colors.green),
        SizedBox(height: 8),
        Text('¡Conexión Exitosa!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: 4),
        Text('Tu dispositivo se ha conectado correctamente.',
            textAlign: TextAlign.center),
      ],
    );
  }
}