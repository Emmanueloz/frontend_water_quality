import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_skeleton.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

  List<NavigationItem> destinations = [
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
      label: "Climan",
      icon: Icons.cloud_outlined,
      selectedIcon: Icons.cloudy_snowing,
    ),
    NavigationItem(
      label: "Editar",
      icon: Icons.edit_outlined,
      selectedIcon: Icons.edit,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      destinations.add(
        NavigationItem(
          label: "Conección",
          icon: Icons.wifi_tethering_outlined,
          selectedIcon: Icons.wifi_tethering,
        ),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MeterProvider>(context, listen: false)
          .fetchMeter(widget.id, widget.idMeter);
    });
  }

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
          Routes.weather.name,
          pathParameters: {
            "id": widget.id,
            "idMeter": widget.idMeter,
          },
        );
      } else if (index == 4) {
        context.goNamed(
          Routes.updateMeter.name,
          pathParameters: {
            "id": widget.id,
            "idMeter": widget.idMeter,
          },
        );
      } else if (index == 5) {
        context.goNamed(
          Routes.connectionMeter.name,
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

    return Consumer<MeterProvider>(
      builder: (context, meterProvider, child) {
        if (meterProvider.isLoading) {
          return const LayoutSkeleton();
        }
        print("Current meter: ${meterProvider.currentMeter}");

        if (!meterProvider.isLoading && meterProvider.currentMeter == null) {
          // Esto dispara el error 404 automático de GoRouter
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!meterProvider.isLoading) {
              GoRouter.of(context).go('/404');
            }
          });
          return const SizedBox.shrink();
        }

        return Layout(
          title: widget.title,
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations,
          builder: (context, screenSize) => widget.builder(context, screenSize),
        );
      },
    );
  }
}
