import 'package:flutter/material.dart';

class AnalysisCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final void Function()? onTab;
  const AnalysisCard({super.key, required this.title, this.icon, this.onTab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(
                icon,
                size: 100,
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
