import 'package:flutter/material.dart';

class ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;
  final TextInputType? keyboardType;

  const ProfileInfoField({
    super.key,
    required this.label,
    required this.value,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
