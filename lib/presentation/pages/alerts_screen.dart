import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/alert_card.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/alerts/main_grid_alerts.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

import '../widgets/layout/layout.dart';
import '../widgets/specific/alerts/alert_tile.dart';

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
          children: screenSize == ScreenSize.mobile
              ? _getAlertsTile(context)
              : _getAlertsCard(context),
        );
      },
    );
  }

  List<Widget> _getAlertsCard(BuildContext context) {
    return [
      AlertCard(
        id: "1",
        title: "El agua esta bueno",
        type: "Bueno",
        onTap: () {
          context.goNamed(
            Routes.alerts.name,
            pathParameters: {
              "type": ListWorkspaces.mine.name,
              'id': "1",
            },
          );
        },
      ),
      AlertCard(
        id: "2",
        title: "El agua esta malo",
        type: "malo",
        onTap: () {
          context.goNamed(
            Routes.alerts.name,
            pathParameters: {
              "type": ListWorkspaces.mine.name,
              'id': "2",
            },
          );
        },
      ),
      AlertCard(
        id: "3",
        title: "El agua es inaceptable",
        type: "inaceptable",
        onTap: () {
          context.goNamed(
            Routes.alerts.name,
            // pathParameters: {
            //   "type": ListWorkspaces.mine.name,
            //   'id': "3",
            // },
          );
        },
      ),
      AlertCard(
        id: "4",
        title: "El agua esta contaminado",
        type: "contaminado",
        onTap: () {
          context.goNamed(
            Routes.alerts.name,
            // pathParameters: {
            //   "type": ListWorkspaces.mine.name,
            //   'id': "4",
            // },
          );
        },
      ),
    ];
  }

List<Widget> _getAlertsTile(BuildContext context) {
    return [
      AlertTile(
        title: "El agua esta bueno",
        type: "Bueno",
        onTap: () {
          print("Navigate to alert 1");
          context.goNamed(
            Routes.alerts.name,
            pathParameters: {
              "type": ListWorkspaces.mine.name,
              'id': "1",
            },
          );
        },
      ),
      AlertTile(
        title: "El agua esta malo",
        type: "malo",
        onTap: () {
          context.goNamed(
            Routes.alerts.name,
            pathParameters: {
              "type": ListWorkspaces.mine.name,
              'id': "2",
            },
          );
        },
      ),
      AlertTile(
        title: "El agua es inaceptable",
        type: "inaceptable",
        onTap: () {
          context.goNamed(
            Routes.alerts.name,
            pathParameters: {
              "type": ListWorkspaces.mine.name,
              'id': "3",
            },
          );
        },
      ),
      AlertTile(
        title: "El agua esta contaminado",
        type: "contaminado",
        onTap: () {
          context.goNamed(
            Routes.alerts.name,
            pathParameters: {
              "type": ListWorkspaces.mine.name,
              'id': "4",
            },
          );
        },
      ),
    ];
  }

}
