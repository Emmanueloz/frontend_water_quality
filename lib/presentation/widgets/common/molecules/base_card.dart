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
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(subtitle ?? ''),
              Spacer(),
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
