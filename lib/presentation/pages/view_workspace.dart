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
        print("Navigate to alerts");
      } else if (index == 2) {
        // Navigate to guests
        print("Navigate to guests");
      } else if (index == 3) {
        // Navigate to settings
        context.goNamed(
          Routes.updateWorkspace.name,
          pathParameters: {
            "type": type.name,
            'id': id,
          },
        );
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
          label: "Editar",
          icon: Icons.edit_outlined,
          selectedIcon: Icons.edit,
        ),
      ],
      builder: (context, screenSize) {
        return MainWorkspace(
          id: id,
          type: type,
          screenSize: screenSize,
        );
      },
    );
  }
}
