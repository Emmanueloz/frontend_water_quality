import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/profile_ui.dart';

class RoleTag extends StatelessWidget {
  final String role;

  const RoleTag({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(ProfileConstants.tagBorderRadius),
      ),
      child: Text(
        role,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.secondary, // Texto que contraste con el fondo
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}