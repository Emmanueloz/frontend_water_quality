import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class LayoutMeters extends StatelessWidget {
  final String title;
  final String id;
  final String idMeter;
  final ListWorkspaces type;
  final int selectedIndex;
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const LayoutMeters({
    super.key,
    required this.title,
    required this.id,
    required this.idMeter,
    required this.type,
    required this.selectedIndex,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      if (index == 0) {
        // Navegar a datos del medidor (actual)
        context.goNamed(
          Routes.meter.name,
          pathParameters: {
            "id": id,
            "idMeter": idMeter,
          },
        );
      } else if (index == 1) {
        // Navegar a historial
        context.goNamed(
          Routes.listRecords.name,
          pathParameters: {
            "id": id,
            "idMeter": idMeter,
          },
        );
      } else if (index == 2) {
        // Navegar a editar medidor (puedes ajustar la ruta si existe)
        // context.goNamed(Routes.editMeter.name, ...);
      }
    }

    return Layout(
      title: title,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationItem(
          label: "Datos",
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics,
        ),
        NavigationItem(
          label: "Historial",
          icon: Icons.history_outlined,
          selectedIcon: Icons.history,
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
