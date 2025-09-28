import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // esquinas redondeadas
      ),
      clipBehavior: Clip.antiAlias, // para que el borde se recorte bien
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
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (subtitle != null) Text(subtitle!),
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
