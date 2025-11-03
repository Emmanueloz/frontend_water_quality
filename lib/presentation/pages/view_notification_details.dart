import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/notification_status.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';
import 'package:frontend_water_quality/presentation/providers/notification_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/notifications/notification_action_modal.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/notifications/other_info.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/notifications/user_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationDetailPage extends StatefulWidget {
  final String notificationId;

  const NotificationDetailPage({
    super.key,
    required this.notificationId,
  });

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  bool _isLoading = true;
  bool _isUpdatingStatus = false;
  String? _errorMessage;
  NotificationModel? _notification;

  @override
  void initState() {
    super.initState();
    _loadNotificationDetails();
  }

  Future<void> _loadNotificationDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final notificationProvider = context.read<NotificationProvider>();
    final result = await notificationProvider
        .getNotificationDetails(widget.notificationId);

    if (mounted) {
      if (result.isSuccess) {
        setState(() {
          _notification = result.value;
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

  void _showActionModal(NotificationStatus action) {
    showDialog(
      context: context,
      builder: (context) => NotificationActionModal(
        action: action,
        onConfirm: () {
          Navigator.of(context).pop();
          _changeNotificationStatus(action);
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _changeNotificationStatus(NotificationStatus status) async {
    setState(() {
      _isUpdatingStatus = true;
    });

    final notificationProvider = context.read<NotificationProvider>();
    final result = await notificationProvider.changeStatus(
      widget.notificationId,
      status,
    );

    if (mounted) {
      setState(() {
        _isUpdatingStatus = false;
      });

      if (result.isSuccess) {
        // Recargar los detalles de la notificación
        await _loadNotificationDetails();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                status == NotificationStatus.accepted
                    ? 'Notificación aprobada exitosamente'
                    : 'Notificación rechazada exitosamente',
              ),
              backgroundColor: status == NotificationStatus.accepted
                  ? Colors.green
                  : Colors.red,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Error al cambiar el estado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Color _getStatusColor(String status, BuildContext context) {
    final theme = Theme.of(context);
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(String status) {
    try {
      return NotificationStatusExtension.fromName(status).nameSpanish;
    } catch (e) {
      return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Layout(
      title: "Detalle de Notificación",
      builder: (context, screenSize) {
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
                  'Error al cargar la notificación',
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
                  onPressed: _loadNotificationDetails,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (_notification == null) {
          return const Center(
            child: Text('No se encontró la notificación'),
          );
        }

        final notification = _notification!;
        final formattedDate = DateFormat("d 'de' MMMM 'de' y 'a las' HH:mm")
            .format(notification.date);
        final statusColor = _getStatusColor(notification.status, context);
        final isMobile = screenSize == ScreenSize.mobile;
        final maxWidth = isMobile ? double.infinity : 800.0;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Card - Estado y Fecha
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: theme.colorScheme.shadow,
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Estado Badge
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: statusColor.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getStatusIcon(notification.status),
                                      color: statusColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _getStatusText(notification.status),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: statusColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Botones de Aprobar/Rechazar (solo para pending)
                              if (notification.status.toLowerCase() ==
                                  'pending') ...[
                                const SizedBox(width: 12),
                                if (_isUpdatingStatus)
                                  const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                else ...[
                                  IconButton(
                                    onPressed: () => _showActionModal(
                                        NotificationStatus.accepted),
                                    icon: const Icon(Icons.check_circle),
                                    color: theme.colorScheme.tertiary,
                                    tooltip: 'Aprobar',
                                    iconSize: 24,
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () => _showActionModal(
                                        NotificationStatus.rejected),
                                    icon: const Icon(Icons.cancel),
                                    color: theme.colorScheme.error,
                                    tooltip: 'Rechazar',
                                    iconSize: 24,
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ],

                              const Spacer(),
                              // Read/Unread indicator
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: notification.read
                                      ? Colors.grey.withValues(alpha: 0.15)
                                      : theme.colorScheme.primary
                                          .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      notification.read
                                          ? Icons.mark_email_read
                                          : Icons.mark_email_unread,
                                      size: 16,
                                      color: notification.read
                                          ? Colors.grey
                                          : theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      notification.read ? 'Leída' : 'No leída',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Título
                          Text(
                            notification.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Fecha
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formattedDate,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cuerpo de la notificación
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: theme.colorScheme.shadow,
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Descripción',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            notification.body,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Parámetros de registro
                  if (notification.recordParameters.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: theme.colorScheme.shadow,
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.analytics_outlined,
                                  color: theme.colorScheme.tertiary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Parámetros de Medición',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...notification.recordParameters.map((param) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        param.parameter,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      param.value.toStringAsFixed(2),
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Información adicional
                  if (notification.aprovedBy != null ||
                      (notification.userIds != null &&
                          notification.userIds!.isNotEmpty)) ...[
                    const SizedBox(height: 16),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: theme.colorScheme.shadow,
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Información Adicional',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (notification.aprovedBy != null) ...[
                              OtherInfo(
                                icon: Icons.check,
                                label: 'Aprobado por',
                                value: notification.aprovedBy!,
                                isMobile: isMobile,
                              ),
                              if (notification.userIds != null &&
                                  notification.userIds!.isNotEmpty)
                                const SizedBox(height: 20),
                            ],
                            if (notification.userIds != null &&
                                notification.userIds!.isNotEmpty)
                              UsersList(userIds: notification.userIds!, isMobile: isMobile,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
