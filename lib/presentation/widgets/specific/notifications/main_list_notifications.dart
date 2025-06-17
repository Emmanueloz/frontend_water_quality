import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/notification_model.dart';
import 'package:frontend_water_quality/presentation/widgets/common/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/notifications/card_list_notifications.dart';

class MainListNotifications extends StatelessWidget {
  final ScreenSize screenSize;

  const MainListNotifications({
    super.key,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    if (screenSize == ScreenSize.smallDesktop ||
        screenSize == ScreenSize.largeDesktop) {
      return Expanded(child: _buildMain(context));
    }

    return _buildMain(context);
  }

  Widget _buildMain(BuildContext context) {
    EdgeInsetsGeometry margin;
    EdgeInsetsGeometry padding;
    int crossAxisCount;
    double childAspectRatio;

    if (screenSize == ScreenSize.smallDesktop) {
      margin = const EdgeInsets.all(10);
      padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 9);
      crossAxisCount = 3;
      childAspectRatio = 1 / 1.2;
    } else if (screenSize == ScreenSize.largeDesktop) {
      margin = const EdgeInsets.all(10);
      padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 9);
      crossAxisCount = 3;
      childAspectRatio = 1 / 0.70;
    } else if (screenSize == ScreenSize.tablet) {
      margin = const EdgeInsets.all(10);
      padding = const EdgeInsets.all(12.0);
      crossAxisCount = 2;
      childAspectRatio = 1 / 1.2;
    } else {
      // Mobile
      margin = const EdgeInsets.all(10);
      padding = const EdgeInsets.all(10.0);
      crossAxisCount = 1;
      childAspectRatio = 1 / 1.2;
    }

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

        return BaseContainer(
          margin: margin,
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: GridView.count(
                    childAspectRatio: childAspectRatio,
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Align(
                        alignment: Alignment
                            .topCenter, // o center, si la quieres centrada verticalmente también
                        child: CardListNotifications(
                          notifications: notifications,
                          screenSize: screenSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    
  }

