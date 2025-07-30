import 'package:flutter/material.dart';

class SuccessView extends StatelessWidget {
  final String title;
  final String subtitle;
  const SuccessView({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), 
        child: Column(  
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle,
                size: 48, color: theme.colorScheme.primary),
            SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 4),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
