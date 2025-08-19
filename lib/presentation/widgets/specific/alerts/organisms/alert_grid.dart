import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/empty_state_view.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_item_builder.dart';
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
              if (onReloadPressed != null)
                IconButton(
                  onPressed: onReloadPressed!,
                  icon: const Icon(Icons.refresh),
                ),
              if (onAddPressed != null)
                ElevatedButton.icon(
                  onPressed: onAddPressed!,
                  icon: const Icon(Icons.add),
                  label: const Text("Crear Alerta"),
                ),
            ],
            screenSize: screenSize,
          ),
          const SizedBox(height: 16),
          if (alerts.isEmpty)
            Expanded(
              child: EmptyStateView(
                title: 'No se encontraron alertas',
                subtitle: 'Las alertas aparecerán aquí cuando sean creadas',
                icon: Icons.warning_amber_outlined,
                onAction: onAddPressed,
                actionText: 'Crear Alerta',
              ),
            )
          else
            Expanded(
              child: GridItemBuilder(
                itemCount: alerts.length,
                itemBuilder: (context, index) => AlertCard(
                  alert: alerts[index],
                  workspaceId: workspaceId,
                  workspaceTitle: title,
                ),
                screenSize: screenSize,
              ),
            ),
        ],
      ),
    );
  }
} 