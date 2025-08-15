import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/presentation/providers/alert_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/grid_loading_skeleton.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/organisms/alert_grid.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_water_quality/router/routes.dart';

class AlertsScreen extends StatefulWidget {
  final String idWorkspace;
  const AlertsScreen({super.key, required this.idWorkspace});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    // Solo cargar alertas si no están ya cargadas para este workspace
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final alertProvider = context.read<AlertProvider>();
      if (alertProvider.currentWorkspaceId != widget.idWorkspace) {
        alertProvider.setWorkspaceId(widget.idWorkspace);
        alertProvider.loadAlerts();
      }
    });
  }

  void _navigateToCreateForm() {
    context.goNamed(
      Routes.createAlerts.name,
      pathParameters: {'id': widget.idWorkspace},
    );
  }

  void _reloadAlerts() {
    final alertProvider = context.read<AlertProvider>();
    alertProvider.forceReload();
  }



  @override
  Widget build(BuildContext context) {
    final alertProvider = context.watch<AlertProvider>();
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    return _buildMain(context, screenSize, alertProvider);
  }

  Widget _buildMain(BuildContext context, ScreenSize screenSize, AlertProvider alertProvider) {
    // Configurar márgenes responsivos
    final margin = screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
        ? const EdgeInsets.all(10)
        : EdgeInsets.zero;

    if (alertProvider.isLoading) {
      return BaseContainer(
        margin: margin,
        child: Column(
          children: [
            Expanded(
              child: GridLoadingSkeleton(screenSize: screenSize),
            ),
          ],
        ),
      );
    }

    // Solo mostrar error real (no estado vacío)
    if (alertProvider.errorMessage != null && 
        alertProvider.errorMessage != 'No se encontraron alertas') {
      return BaseContainer(
        margin: margin,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 16),
              Text(
                alertProvider.errorMessage!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  alertProvider.cleanError();
                  alertProvider.loadAlerts();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return AlertGrid(
      alerts: alertProvider.alerts,
      screenSize: screenSize,
      title: 'Alertas',
      workspaceId: widget.idWorkspace,
      onAddPressed: _navigateToCreateForm,
      onReloadPressed: _reloadAlerts,
    );
  }
}
