import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class LayoutMeters extends StatefulWidget {
  final String title;
  final String id;
  final String idMeter;
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const LayoutMeters({
    super.key,
    required this.title,
    required this.id,
    required this.idMeter,
    required this.builder,
  });

  @override
  State<LayoutMeters> createState() => _LayoutMetersState();
}

class _LayoutMetersState extends State<LayoutMeters> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      if (index == 0) {
        context.goNamed(
          Routes.meter.name,
          pathParameters: {
            "id": widget.id,
            "idMeter": widget.idMeter,
          },
        );
      } else if (index == 1) {
        context.goNamed(
          Routes.listRecords.name,
          pathParameters: {
            "id": widget.id,
            "idMeter": widget.idMeter,
          },
        );
      } else if (index == 2) {
        context.goNamed(
          Routes.analysisRecords.name,
          pathParameters: {
            "id": widget.id,
            "idMeter": widget.idMeter,
          },
        );
      } else if (index == 3) {
        context.goNamed(
          Routes.connectionMeter.name,
          pathParameters: {
            "id": widget.id,
            "idMeter": widget.idMeter,
          },
        );
      } else if (index == 4) {
        print("Weather");
        context.goNamed(
          Routes.weather.name,
          pathParameters: {
            "id": widget.id,
            "idMeter": widget.idMeter,
          },
        );
      } else if (index == 5) {
        context.goNamed(
          Routes.updateMeter.name,
          pathParameters: {
            "id": widget.id,
            "idMeter": widget.idMeter,
          },
        );
      }

      setState(() {
        currentIndex = index;
      });
    }

    return Layout(
      title: widget.title,
      selectedIndex: currentIndex,
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
          label: "Analisis",
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics,
        ),
        NavigationItem(
          label: "Conección",
          icon: Icons.wifi_tethering_outlined,
          selectedIcon: Icons.wifi_tethering,
        ),
        NavigationItem(
          label: "Climan",
          icon: Icons.cloud_outlined,
          selectedIcon: Icons.cloudy_snowing,
        ),
        NavigationItem(
          label: "Editar",
          icon: Icons.edit_outlined,
          selectedIcon: Icons.edit,
        ),
      ],
      builder: (context, screenSize) => widget.builder(context, screenSize),
    );
  }
}
