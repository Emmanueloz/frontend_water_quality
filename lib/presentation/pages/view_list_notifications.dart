import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/notifications/main_list_notifications.dart';

class ViewListNotifications extends StatelessWidget {
  const ViewListNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notifications = [
      NotificationModel(
        id: "1",
        read: false,
        title: "Alerta de calidad del agua",
        body: "Los niveles de pH han superado el límite seguro.",
        userId: "user123",
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: "2",
        read: true,
        title: "Mantenimiento programado",
        body: "El mantenimiento del sistema se realizará el próximo lunes.",
        userId: "user123",
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      NotificationModel(
        id: "3",
        read: false,
        title: "Actualización de software",
        body: "Se ha lanzado una nueva versión del software del medidor.",
        userId: "user123",
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      NotificationModel(
        id: "4",
        read: true,
        title: "Informe mensual",
        body: "El informe mensual de calidad del agua está disponible.",
        userId: "user123",
        date: DateTime.now().subtract(const Duration(days: 4)),
      ),
      NotificationModel(
        id: "5",
        read: false,
        title: "Alerta de temperatura",
        body: "La temperatura del agua ha superado el límite seguro.",
        userId: "user123",
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      NotificationModel(
        id: "6",
        read: true,
        title: "Notificación de seguridad",
        body: "Se ha detectado una posible fuga en el sistema.",
        userId: "user123",
        date: DateTime.now().subtract(const Duration(days: 6)),
      ),
      NotificationModel(
        id: "7",
        read: false,
        title: "Alerta de turbidez",
        body: "Los niveles de turbidez han superado el límite seguro.",
        userId: "user123",
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
      NotificationModel(
        id: "8",
        read: true,
        title: "Recordatorio de mantenimiento",
        body: "Recuerda realizar el mantenimiento del medidor este mes.",
        userId: "user123",
        date: DateTime.now().subtract(const Duration(days: 8)),
      ),
    ];

    return Layout(
      title: "Notificaciones",
      builder: (context, screenSize) {
        return MainListNotifications(
            screenSize: screenSize,
            notifications: notifications,
        );
      },
    );
  }
}
