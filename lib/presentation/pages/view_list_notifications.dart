import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/notification_status.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
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

  bool _isMobile(screenSize) => screenSize == ScreenSize.mobile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Layout(
      title: "Notificaciones",
      builder: (context, screenSize) {
        return Column(
          children: [
            // Filtros — ahora con LayoutBuilder para controlar ancho y centrado
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(builder: (context, constraints) {
                final bool isMobile = _isMobile(screenSize);
                // En non-mobile limitamos el ancho al 60% del disponible o 720px max
                final double containerWidth = isMobile
                    ? constraints.maxWidth
                    : min(constraints.maxWidth * 0.9, 720);

                return Align(
                  alignment: Alignment.topRight,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: containerWidth),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment:
                          isMobile ? MainAxisAlignment.start : MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Selector de estado: en mobile ocupa todo el ancho; en desktop tiene ancho reducido.
                        if (isMobile)
                          // mobile: dropdown full width
                          Expanded(
                            child: DropdownButtonFormField<NotificationStatus>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              items: NotificationStatus.values.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status.nameSpanish),
                                );
                              }).toList(),
                              onChanged: _changeStatusFilter,
                            ),
                          )
                        else
                          // non-mobile: narrow dropdown (suficiente para ~8 caracteres)
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<NotificationStatus>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

                        // Espaciado entre elementos — en mobile un poco menor
                        SizedBox(width: isMobile ? 12 : 16),

                        // Filtro de leídas/no leídas
                        FilterChip(
                          label: Text(_showOnlyUnread ? 'No leídas' : 'Todas'),
                          selected: _showOnlyUnread,
                          onSelected: (_) => _toggleFilter(),
                          visualDensity: VisualDensity.compact,
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
                );
              }),
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
