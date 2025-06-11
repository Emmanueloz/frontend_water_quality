import 'package:flutter/material.dart';

class AlertTile extends StatelessWidget {
  final String title;
  final String type;
  final void Function()? onTap;

  const AlertTile({
    super.key,
    required this.title,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            title: Text(
              title,
              style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Tipo: $type',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
    );
  }
}
