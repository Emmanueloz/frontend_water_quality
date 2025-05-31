import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/pages/profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            user.name,
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.surface, // Texto blanco sobre fondo oscuro
            ),
          ),
          const SizedBox(height: 8),
          Chip(label: Text(user.role)),
        ],
      ),
    );
  }
}