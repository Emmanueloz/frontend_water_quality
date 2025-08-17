import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/theme/theme.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.colorScheme.tertiary,
          width: 1,
        ),
      ),
      elevation: 3,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.colorScheme.surface,
              AppTheme.colorScheme.tertiary.withOpacity(0.1),
            ],
          ),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            'Tipo: $type',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textColor.withOpacity(0.7),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: AppTheme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
