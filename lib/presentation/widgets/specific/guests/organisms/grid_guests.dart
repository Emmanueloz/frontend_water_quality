import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/empty_state_view.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/guests/molecules/guests_cards.dart';

class GuestGrid extends StatelessWidget {
  final List<Guest> guests;
  final ScreenSize screenSize;
  final String title;
  final String workspaceId;
  final VoidCallback? onAddPressed;
  final VoidCallback? onReloadPressed;

  const GuestGrid({
    super.key,
    required this.guests,
    required this.screenSize,
    required this.workspaceId,
    this.title = "Invitados",
    this.onAddPressed,
    this.onReloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _buildMain(context);
  }

  Widget _buildMain(BuildContext context) {
    final config = _gridConfig(screenSize);

    return BaseContainer(
      margin: EdgeInsets.zero, // Sin márgenes, la página principal los maneja
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ButtonActions(
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (onAddPressed != null && guests.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: onAddPressed!,
                  icon: const Icon(Icons.person_add),
                  label: const Text("Agregar Invitado"),
                ),
              if (onReloadPressed != null)
                ElevatedButton.icon(
                  onPressed: onReloadPressed!,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Recargar"),
                ),
            ],
            screenSize: screenSize,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: guests.isEmpty 
                ? EmptyStateView(
                    title: 'No se encontraron invitados',
                    subtitle: 'Los invitados aparecerán aquí cuando sean agregados',
                    icon: Icons.people_outline,
                    onAction: onAddPressed,
                    actionText: 'Agregar Invitado',
                  )
                : SingleChildScrollView(
                    child: GridView.count(
                      crossAxisCount: config.crossAxisCount,
                      childAspectRatio: config.childAspectRatio,
                      crossAxisSpacing: config.gap,
                      mainAxisSpacing: config.gap,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: guests.map((guest) => GuestCard(
                        guest: guest,
                        workspaceId: workspaceId,
                        workspaceTitle: title,
                      )).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  GridConfig _gridConfig(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.mobile:
        return GridConfig(
          crossAxisCount: 1,
          childAspectRatio: 1 / 0.4,
          gap: 5,
        );
      case ScreenSize.tablet:
        return GridConfig(
          crossAxisCount: 2,
          childAspectRatio: 1 / 0.4,
          gap: 5,
        );
      case ScreenSize.smallDesktop:
        return GridConfig(
          crossAxisCount: 3,
          childAspectRatio: 1 / 0.5,
          gap: 10,
        );
      case ScreenSize.largeDesktop:
        return GridConfig(
          crossAxisCount: 4,
          childAspectRatio: 1 / 0.5,
          gap: 16,
        );
    }
  }
}

class GridConfig {
  final int crossAxisCount;
  final double childAspectRatio;
  final double gap;

  GridConfig({
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.gap,
  });
} 