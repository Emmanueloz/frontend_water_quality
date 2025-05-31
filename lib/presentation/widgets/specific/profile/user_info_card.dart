import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/profile_ui.dart';
import 'package:frontend_water_quality/presentation/pages/profile.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/profile/profile_info_field.dart';

class UserInfoCard extends StatelessWidget {
  final UserProfile user;
  final double width;

  const UserInfoCard({
    super.key,
    required this.user,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: ProfileConstants.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface, // Fondo claro
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(ProfileConstants.cardBorderRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileInfoField(
            label: 'Nombre de usuario',
            value: user.name,
          ),
          const SizedBox(height: 20),
          ProfileInfoField(
            label: 'Correo electrónico',
            value: user.email,
          ),
          const SizedBox(height: 20),
          ProfileInfoField(
            label: 'Teléfono',
            value: user.phone,
          ),
          const SizedBox(height: 20),
          ProfileInfoField(
            label: 'Rol',
            value: user.role,
          ),
        ],
      ),
    );
  }
}