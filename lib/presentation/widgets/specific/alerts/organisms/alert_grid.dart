import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/empty_state_view.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_loading_skeleton.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/molecules/alert_card.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';

class AlertGrid extends StatelessWidget {
  final List<Alert> alerts;
  final ScreenSize screenSize;
  final String title;
  final String workspaceId;
  final VoidCallback? onAddPressed;
  final VoidCallback? onReloadPressed;

  const AlertGrid({
    super.key,
    required this.alerts,
    required this.screenSize,
    required this.title,
    required this.workspaceId,
    this.onAddPressed,
    this.onReloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _buildMain(context);
  }

  Widget _buildMain(BuildContext context) {
    final config = _gridConfig(screenSize);
    final margin = screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
        ? const EdgeInsets.all(10)
        : EdgeInsets.zero;

    return BaseContainer(
      margin: margin,
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
              if (onAddPressed != null)
                ElevatedButton.icon(
                  onPressed: onAddPressed!,
                  icon: const Icon(Icons.add),
                  label: const Text("Crear Alerta"),
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
            child: alerts.isEmpty 
                ? EmptyStateView(
                    title: 'No se encontraron alertas',
                    subtitle: 'Las alertas aparecerán aquí cuando sean creadas',
                    icon: Icons.warning_amber_outlined,
                    onAction: onAddPressed,
                    actionText: 'Crear Alerta',
                  )
                : SingleChildScrollView(
                    child: GridView.count(
                      crossAxisCount: config.crossAxisCount,
                      childAspectRatio: config.childAspectRatio,
                      crossAxisSpacing: config.gap,
                      mainAxisSpacing: config.gap,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: alerts.map((alert) => AlertCard(
                        alert: alert,
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