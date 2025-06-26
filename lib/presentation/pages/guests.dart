import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';

class GuestsPage extends StatelessWidget {
  final String title;
  const GuestsPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: title,
      builder: (context, screenSize) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_outlined, size: 64, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            Text(
              'No guests yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey.shade800,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You can add guests using the button above.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
