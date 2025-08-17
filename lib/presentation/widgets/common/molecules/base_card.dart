import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/theme/theme.dart';

class BaseCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Chip? chip;
  final void Function()? onTap;

  const BaseCard({
    super.key,
    required this.title,
    this.subtitle,
    this.chip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.colorScheme.tertiary,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      ),
                ),
              ],
              const Spacer(),
              if (chip != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: chip!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
