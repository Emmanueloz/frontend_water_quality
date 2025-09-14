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
      ),
      label: Container(
        padding: EdgeInsets.all(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(username),
            Text(email),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
