import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/interface/alert_item.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/main_grid_alerts.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

import '../widgets/layout/layout.dart';

class AlertsScreen extends StatelessWidget {
  final String idWorkspace;
  const AlertsScreen({super.key, required this.idWorkspace});

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      if (index == 0) {
        // Navigate to meters
        print("Navigate to meters");
      } else if (index == 1) {
        // Navigate to alerts
        context.goNamed(
          Routes.alerts.name,
          pathParameters: {
            "id": idWorkspace,
          },
        );
      } else if (index == 2) {
        // Navigate to guests
        print("Navigate to guests");
      } else if (index == 3) {
        // Navigate to settings
        print("Navigate to settings");
      }
    }

    return Layout(
      title: "Alertas del espacio de trabajo $idWorkspace",
      selectedIndex: 1,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationItem(
          label: "Medidores",
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics,
        ),
        NavigationItem(
          label: "Alertas",
          icon: Icons.alarm_outlined,
          selectedIcon: Icons.alarm,
        ),
        NavigationItem(
          label: "Invitados",
          icon: Icons.people_outline,
          selectedIcon: Icons.people,
        ),
        NavigationItem(
          label: "Configuración",
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings,
        ),
      ],
      builder: (context, screenSize) {
        return MainGridAlerts(
          screenSize: screenSize,
          alertItems: [
            AlertItem(
              id: "1",
              title: "El agua esta bueno",
              type: "Bueno",
            ),
            AlertItem(
              id: "2",
              title: "El agua esta malo",
              type: "malo",
            ),
            AlertItem(
              id: "3",
              title: "El agua es inaceptable",
              type: "inaceptable",
            ),
          ],
        );
      },
    );
  }

}
