import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/list_workspaces.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/main_meter.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class ViewMeter extends StatelessWidget {
  final String id;
  final String idMeter;
  final ListWorkspaces type;
  const ViewMeter(
      {super.key, required this.idMeter, required this.id, required this.type});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Medidor $idMeter",
      selectedIndex: 0,
      onDestinationSelected: (int index) {
        if (index == 0) {
          // Navigate to meters
          print("Navigate to meters");
        } else if (index == 1) {
          // Navigate to alerts
          context.goNamed(
            Routes.listRecords.name,
            pathParameters: {
              "id": id,
              "idMeter": idMeter,
              "type": type.name,
            },
          );
        }
      },
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
      builder: (context, screenSize) {
        return MainMeter(
          idMeter: idMeter,
          screenSize: screenSize,
          id: id,
          type: type,
        );
      },
    );
  }
}
