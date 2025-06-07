import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/main_workspace.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class ViewWorkspace extends StatelessWidget {
  final String id;
  final ListWorkspaces type;
  const ViewWorkspace({super.key, required this.id, required this.type});

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
            "id": id,
            "type": type.name,
          },
        );
        print("Navigate to alerts");
      } else if (index == 2) {
        // Navigate to guests
        print("Navigate to guests");
      } else if (index == 3) {
        // Navigate to settings
        print("Navigate to settings");
      }
    }

    return Layout(
      title: "Espacio de trabajo $id",
      selectedIndex: 0,
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
        return MainWorkspace(
          id: id,
          idMeter: "1",
          type: type,
          screenSize: screenSize,
        );
      },
    );
  }
}
