import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? tag;
  final IconData? icon;
  final Chip? chip;
  final String? state;
  final void Function()? onTap;

  const BaseCard({
    super.key,
    required this.title,
    this.subtitle,
    this.chip,
    this.onTap,
    this.tag,
    this.icon,
    this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.shadow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.tertiary,
                width: 10,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state != null && icon != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.62),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 6,
                        children: [
                          Text(
                            state!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            icon,
                            size: 18,
                            color: theme.colorScheme.tertiary,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              else
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (tag != null)
                Text(
                  tag!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary.withAlpha(185),
                  ),
                ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.25,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
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
