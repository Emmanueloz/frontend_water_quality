import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/profile_ui.dart';
import 'package:frontend_water_quality/presentation/pages/profile.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/profile/profile_info_field.dart';

import '../../common/action_button.dart';
import '../../common/base_container.dart';

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
    // final colorScheme = Theme.of(context).colorScheme;

    return BaseContainer(
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: ProfileConstants.verticalPadding,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 15,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ActionButton(
                  onPressed: () {
                    // Lógica de Resetear
                  },
                  label: 'Resetear',
                  style: ActionButtonStyle.outlined, // botón con borde
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  width: _getWithActionButton(),
                ),
              ActionButton(
                  onPressed: () {
                    // Lógica de Guardar
                  },
                  label: 'Guardar',
                  style: ActionButtonStyle.filled, // botón con fondo sólido
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  width: _getWithActionButton(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  double _getWithActionButton() {
    return width == double.infinity ? 150 : 200;
  }
}
