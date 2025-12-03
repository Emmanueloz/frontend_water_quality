import 'package:flutter/material.dart';

class ButtonProfile extends StatelessWidget {
  final String username;
  final String email;
  final String? role;
  final void Function()? onPressed;

  const ButtonProfile({
    super.key,
    required this.username,
    required this.email,
    this.role,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            email,
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (role != null && role!.isNotEmpty)
            Text(
              role!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
