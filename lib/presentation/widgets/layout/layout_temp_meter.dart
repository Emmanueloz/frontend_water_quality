import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:go_router/go_router.dart';

class LayoutTempMeter extends StatelessWidget {
  final String title;
  final String id;
  final String idMeter;
  final int selectedIndex;
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const LayoutTempMeter({
    super.key,
    required this.title,
    required this.id,
    required this.idMeter,
    required this.selectedIndex,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      final base = '/workspaces/$id/temp-meter/$idMeter';
      if (index == 0) {
        context.go('$base');
      } else if (index == 1) {
        context.go('$base/records');
      } else if (index == 2) {
        context.go('$base/predictions');
      } else if (index == 3) {
        context.go('$base/interpretations');
      } else if (index == 4) {
        context.go('$base/connection');
      } else if (index == 5) {
        context.go('$base/update');
      }
    }

    return Layout(
      title: title,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationItem(
          label: "Monitoreo",
          icon: Icons.speed_outlined,
          selectedIcon: Icons.speed_rounded,
        ),
        NavigationItem(
          label: "Registros",
          icon: Icons.line_axis_outlined,
          selectedIcon: Icons.line_axis,
        ),
        NavigationItem(
          label: "Predicciones",
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics,
        ),
        NavigationItem(
          label: "Interpretación",
          icon: Icons.auto_awesome_outlined,
          selectedIcon: Icons.auto_awesome,
        ),
        NavigationItem(
          label: "Conección",
          icon: Icons.wifi_tethering_outlined,
          selectedIcon: Icons.wifi_tethering,
        ),
        NavigationItem(
          label: "Editar",
          icon: Icons.edit_outlined,
          selectedIcon: Icons.edit,
        ),
      ],
      builder: (context, screenSize) =>
          Expanded(child: builder(context, screenSize)),
    );
  }
}
