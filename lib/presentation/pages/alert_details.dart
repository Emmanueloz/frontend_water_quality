import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/alert.dart';
import 'package:frontend_water_quality/presentation/providers/alert_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_water_quality/router/routes.dart';

class AlertDetailsPage extends StatefulWidget {
  final String alertId;
  final String workspaceTitle;

  const AlertDetailsPage({
    super.key,
    required this.alertId,
    required this.workspaceTitle,
  });

  @override
  State<AlertDetailsPage> createState() => _AlertDetailsPageState();
}

class _AlertDetailsPageState extends State<AlertDetailsPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAlertDetails();
  }

  void _loadAlertDetails() async {
    setState(() {
      _isLoading = true;
    });

    final alertProvider = context.read<AlertProvider>();
    await alertProvider.getAlertDetails(widget.alertId);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteAlert() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Está seguro de que desea eliminar esta alerta? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      final alertProvider = context.read<AlertProvider>();
      await alertProvider.deleteAlert(widget.alertId);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (alertProvider.errorMessage == null) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Alerta eliminada exitosamente'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(alertProvider.errorMessage ?? 'Error al eliminar la alerta'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _editAlert() {
    final alertProvider = context.read<AlertProvider>();
    final alert = alertProvider.selectedAlert;
    
    if (alert != null) {
      context.pushNamed(
        Routes.updateAlerts.name,
        pathParameters: {'id': widget.alertId},
        extra: alert,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Alerta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildDetails(context, screenSize),
    );
  }

  Widget _buildDetails(BuildContext context, screenSize) {
    final margin = screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
        ? const EdgeInsets.all(10)
        : const EdgeInsets.all(20);

    return Consumer<AlertProvider>(
      builder: (context, alertProvider, child) {
        if (_isLoading) {
          return Container(
            margin: margin,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (alertProvider.errorMessage != null) {
          return Container(
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
                      _loadAlertDetails();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final alert = alertProvider.selectedAlert;
        if (alert == null) {
          return Container(
            margin: margin,
            child: const Center(
              child: Text('Alerta no encontrada'),
            ),
          );
        }

        return Container(
          margin: margin,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header con botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Detalles de la Alerta',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _editAlert,
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _deleteAlert,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.delete),
                        label: const Text('Eliminar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Información de la alerta
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título
                          Text(
                            alert.title,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tipo de alerta
                          Row(
                            children: [
                              Text(
                                'Tipo: ',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Chip(
                                label:                                 Text(
                                  _translateType(alert.type),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: _getTypeColor(alert.type),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Estado
                          Row(
                            children: [
                              Text(
                                'Estado: ',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  alert.isActive ? 'Activa' : 'Inactiva',
                                  style: TextStyle(
                                    color: alert.isActive ? Colors.white : Colors.black,
                                  ),
                                ),
                                backgroundColor: alert.isActive ? Colors.green : Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Descripción
                          Text(
                            'Descripción:',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            alert.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),

                          // Fecha de creación
                          Row(
                            children: [
                              Text(
                                'Creada: ',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _formatDate(alert.createdAt),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'good':
        return Colors.green;
      case 'moderate':
        return Colors.blue;
      case 'poor':
        return Colors.orange;
      case 'dangerous':
        return Colors.red;
      case 'excellent':
        return Colors.green[700]!;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _translateType(String type) {
    switch (type.toLowerCase()) {
      case 'good':
        return 'Bueno';
      case 'moderate':
        return 'Moderado';
      case 'poor':
        return 'Malo';
      case 'dangerous':
        return 'Peligroso';
      case 'excellent':
        return 'Excelente';
      default:
        return type.capitalize();
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
} 