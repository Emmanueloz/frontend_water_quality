import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/sidebar.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/main_workspace.dart';

class ViewWorkspace extends StatelessWidget {
  final String id;
  const ViewWorkspace({super.key, required this.id});

  void onDestinationSelected(BuildContext context, int index) {
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
      print("Navigate to settings");
    }
  }

  Widget _buildDesktopContent(BuildContext context, ScreenSize screenSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Sidebar(
          screenSize: screenSize,
          selectedIndex: 0,
          onDestinationSelected: (index) =>
              onDestinationSelected(context, index),
          destinations: [
            NavigationRailDestination(
              icon: const Icon(Icons.analytics_outlined),
              selectedIcon: const Icon(Icons.analytics),
              label: Text("Medidores"),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.alarm_outlined),
              selectedIcon: const Icon(Icons.alarm),
              label: Text("Alertas"),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.people_outline),
              selectedIcon: const Icon(Icons.people),
              label: Text("Invitados"),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: Text("Configuración"),
            ),
          ],
        ),

        // Main content area with workspace grid
        MainWorkspace(
          id: id,
          idMeter: "1",
          screenSize: screenSize,
        ),
      ],
    );
  }

  Widget _buildMobileContent(BuildContext context, ScreenSize screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        MainWorkspace(
          id: "1",
          idMeter: "1",
          screenSize: screenSize,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Espacio de trabajo $id",
      selectedIndex: 0,
      onDestinationSelected: (int index) =>
          onDestinationSelected(context, index),
      destinations: [
        NavigationDestination(
          label: "Medidores",
          icon: const Icon(Icons.analytics_outlined),
          selectedIcon: const Icon(Icons.analytics),
        ),
        NavigationDestination(
          label: "Alertas",
          icon: const Icon(Icons.alarm_outlined),
          selectedIcon: const Icon(Icons.alarm),
        ),
        NavigationDestination(
          label: "Invitados",
          icon: const Icon(Icons.people_outline),
          selectedIcon: const Icon(Icons.people),
        ),
        NavigationDestination(
          label: "Configuración",
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
        ),
      ],
      builder: (context, screenSize) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet
                  ? _buildMobileContent(
                      context,
                      screenSize,
                    )
                  : _buildDesktopContent(
                      context,
                      screenSize,
                    ),
        );
      },
    );
  }
}
