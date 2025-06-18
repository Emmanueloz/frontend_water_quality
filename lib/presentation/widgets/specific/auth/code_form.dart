import 'package:flutter/material.dart';

class CodeForm extends StatefulWidget {
  final void Function(String code) onValid;

  const CodeForm({super.key, required this.onValid});

  @override
  State<CodeForm> createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final code = _controller.text.trim();
    if (code.length != 6 || int.tryParse(code) == null) {
      _showSnackBar("El código debe tener 6 dígitos numéricos");
      return;
    }

    widget.onValid(code);
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: 'Código de verificación'),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: _submit,
            child: const Text('Verificar'),
          ),
        ),
      ],
    );
  }
}
