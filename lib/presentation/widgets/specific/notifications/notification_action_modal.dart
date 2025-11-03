import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/notification_status.dart';

class NotificationActionModal extends StatelessWidget {
  final NotificationStatus action;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const NotificationActionModal({
    super.key,
    required this.action,
    required this.onConfirm,
    required this.onCancel,
  });

  String get _title {
    return action == NotificationStatus.accepted
        ? 'Aprobar Notificación'
        : 'Rechazar Notificación';
  }

  String get _message {
    return action == NotificationStatus.accepted
        ? 'Al aprobar esta notificación, se enviará automáticamente un correo electrónico a todos los visitantes del espacio de trabajo.'
        : 'Al rechazar esta notificación, no se enviará ningún correo electrónico a los visitantes del espacio de trabajo.';
  }

  IconData get _icon {
    return action == NotificationStatus.accepted
        ? Icons.check_circle_outline
        : Icons.cancel_outlined;
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);
    return action == NotificationStatus.accepted
        ? theme.colorScheme.tertiary // Green-500
        : const Color(0xFFEF4444); // Red-500
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 480 : size.width * 0.9,
          maxHeight: size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 32.0 : 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono con animación
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _icon,
                          size: 56,
                          color: color,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: isDesktop ? 24 : 20),

                // Título
                Text(
                  _title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isDesktop ? 16 : 12),

                // Mensaje
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    _message,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: isDesktop ? 32 : 24),

                // Advertencia sutil
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: color,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Esta acción no se puede deshacer',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isDesktop ? 28 : 24),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: isDesktop ? 16 : 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: theme.colorScheme.outline.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isDesktop ? 16 : 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          shadowColor: color.withValues(alpha: 0.4),
                        ),
                        child: Text(
                          'Confirmar',
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}