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
    final theme = Theme.of(context);
    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(10.0),
      ),
      icon: const Icon(
        Icons.account_circle,
        size: 30,
      ),
      label: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
