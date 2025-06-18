import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class LayoutWorkspace extends StatelessWidget {
  final String title;
  final String id;
  final int selectedIndex;
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const LayoutWorkspace({
    super.key,
    required this.title,
    required this.id,
    required this.builder,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      if (index == 0) {
        // Navigate to meters
        print("Navigate to meters");

        context.goNamed(
          Routes.workspace.name,
          pathParameters: {
            "id": id,
          },
        );
      } else if (index == 1) {
        // Navigate to alerts
        context.goNamed(
          Routes.alerts.name,
          pathParameters: {
            "id": id,
          },
        );
        print("Navigate to alerts");
      } else if (index == 2) {
        // Navigate to guests
        print("Navigate to guests");
      } else if (index == 3) {
        // Navigate to guests
        print("Locations meters");
      } else if (index == 4) {
        // Navigate to settings
        context.goNamed(
          Routes.updateWorkspace.name,
          pathParameters: {
            'id': id,
          },
        );
      }
    }

    return Layout(
      title: title,
      selectedIndex: selectedIndex,
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
          label: "Ubicaciones",
          icon: Icons.location_on_outlined,
          selectedIcon: Icons.location_on,
        ),
        NavigationItem(
          label: "Editar",
          icon: Icons.edit_outlined,
          selectedIcon: Icons.edit,
        ),
      ],
      builder: builder,
    );
  }
}
