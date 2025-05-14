import 'package:flutter/material.dart';

class ButtonProfile extends StatelessWidget {
  final String username;
  final String email;
  final void Function()? onPressed;

  const ButtonProfile({
    super.key,
    required this.username,
    required this.email,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(
        Icons.account_circle,
        size: 30,
        color: Colors.black,
      ),
      label: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          Text(
            email,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
