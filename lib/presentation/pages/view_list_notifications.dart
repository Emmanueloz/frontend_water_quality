import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/notification_status.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';
import 'package:frontend_water_quality/presentation/providers/notification_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/notifications/main_list_notifications.dart';
import 'package:provider/provider.dart';

class ViewListNotifications extends StatefulWidget {
  const ViewListNotifications({super.key});

  @override
  State<ViewListNotifications> createState() => _ViewListNotificationsState();
}

class _ViewListNotificationsState extends State<ViewListNotifications> {
  bool _isLoading = true;
  String? _errorMessage;
  List<NotificationModel> _notifications = [];
  bool _showOnlyUnread = false;
  NotificationStatus _selectedStatus = NotificationStatus.pending;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final notificationProvider = context.read<NotificationProvider>();
    final result = await notificationProvider.listNotifications(
      _showOnlyUnread,
      _selectedStatus,
    );

    if (mounted) {
      if (result.isSuccess) {
        setState(() {
          _notifications = result.value!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result.message;
          _isLoading = false;
        });
      }
    }
  }

  void _toggleFilter() {
    setState(() {
      _showOnlyUnread = !_showOnlyUnread;
    });
    _loadNotifications();
  }

  void _changeStatusFilter(NotificationStatus? status) {
    if (status != null) {
      setState(() {
        _selectedStatus = status;
      });
      _loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Layout(
      title: "Notificaciones",
      builder: (context, screenSize) {
        return Column(
          children: [
            // Filtros
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Filtro de estado
                  Expanded(
                    child: DropdownButtonFormField<NotificationStatus>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(),
                      ),
                      items: NotificationStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.nameSpanish),
                        );
                      }).toList(),
                      onChanged: _changeStatusFilter,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Filtro de leídas/no leídas
                  FilterChip(
                    label: Text(_showOnlyUnread ? 'No leídas' : 'Todas'),
                    selected: _showOnlyUnread,
                    onSelected: (_) => _toggleFilter(),
                  ),
                  const SizedBox(width: 8),
                  // Botón de refrescar
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadNotifications,
                    tooltip: 'Actualizar',
                  ),
                ],
              ),
            ),

            // Contenido
            Expanded(
              child: _buildContent(screenSize, theme),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(dynamic screenSize, ThemeData theme) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar notificaciones',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadNotifications,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay notificaciones',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'No se encontraron notificaciones con los filtros seleccionados',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return MainListNotifications(
      screenSize: screenSize,
      notifications: _notifications,
    );
  }
}
