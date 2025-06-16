import 'package:flutter/material.dart';

class RecoveryPasswordPage extends StatelessWidget {
  const RecoveryPasswordPage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
      ),
      body: Center(
        child: Text(
          'Recovery Password Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
