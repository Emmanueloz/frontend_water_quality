import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/notifications/main_list_notifications.dart';

class ViewListNotifications extends StatelessWidget {
  const ViewListNotifications({super.key});

  @override
  Widget build(BuildContext context) {

    return Layout(
      title: "Notificaciones",
      builder: (context, screenSize) {
        return MainListNotifications(
          screenSize: screenSize,
        );
      },
    );
  }
}
