import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_skeleton.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/presentation/providers/workspace_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/router/routes.dart';

class LayoutWorkspace extends StatefulWidget {
  final String title;
  final String id;
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const LayoutWorkspace({
    super.key,
    required this.title,
    required this.id,
    required this.builder,
  });

  @override
  State<LayoutWorkspace> createState() => _LayoutWorkspaceState();
}

class _LayoutWorkspaceState extends State<LayoutWorkspace> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<WorkspaceProvider>(context, listen: false)
        .fetchWorkspace(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    void onDestinationSelected(int index) {
      if (index == 0) {
        // Navigate to meters
        context.goNamed(
          Routes.workspace.name,
          pathParameters: {
            "id": widget.id,
          },
        );
      } else if (index == 1) {
        // Navigate to alerts
        context.goNamed(
          Routes.alerts.name,
          pathParameters: {
            "id": widget.id,
          },
        );
      } else if (index == 2) {
        // Navigate to guests
        context.goNamed(
          Routes.guests.name,
          pathParameters: {
            "id": widget.id,
          },
        );
      } else if (index == 3) {
        // Navigate to location
        context.goNamed(
          Routes.locationMeters.name,
          pathParameters: {
            "id": widget.id,
          },
        );
        print("Locations meters");
      } else if (index == 4) {
        // Navigate to settings
        context.goNamed(
          Routes.updateWorkspace.name,
          pathParameters: {
            'id': widget.id,
          },
        );
      }

      setState(() {
        currentIndex = index;
      });
    }

    return Consumer<WorkspaceProvider>(
      builder: (context, workspaceProvider, child) {
        if (workspaceProvider.isLoading) {
          return const LayoutSkeleton();
        }

        if (workspaceProvider.currentWorkspace == null) {
          // Esto dispara el error 404 automático de GoRouter
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).go('/404');
          });
          return const SizedBox.shrink();
        }

        return Layout(
          title: workspaceProvider.isLoading
              ? "Cargando..."
              : workspaceProvider.currentWorkspace?.name ??
                  "Espacio no encontrado",
          selectedIndex: currentIndex,
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
          builder: (context, screenSize) => widget.builder(context, screenSize),
        );
      },
    );
  }
}
