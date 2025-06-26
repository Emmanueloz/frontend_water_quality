import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed ?? () {},
      icon: const Icon(Icons.add),
      label: const Text('Add Guest'),
    );
  }
}
