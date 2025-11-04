import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/user.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

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
            user.username ?? 'Usuario',
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Chip(
              label: Text(
            user.rol?.name ?? 'Sin rol',
            style: TextStyle(fontSize: 14),
          )),
        ],
      ),
    );
  }
}
