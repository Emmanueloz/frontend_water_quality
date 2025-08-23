import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/work_roles.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/core/interface/route_properties.dart';
import 'package:frontend_water_quality/domain/models/workspace.dart';
import 'package:frontend_water_quality/presentation/pages/error_page.dart';
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
  late Future<Result<Workspace>> _workspaceFuture;

  @override
  void initState() {
    super.initState();
    _workspaceFuture = _fetchWorkspace();
  }

  Future<Result<Workspace>> _fetchWorkspace() async {
    final provider = Provider.of<WorkspaceProvider>(context, listen: false);
    final result = await provider.getWorkspaceById(widget.id);
    provider.confirmWorkspaceReloaded(widget.id);
    return result;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<WorkspaceProvider>(context);
    if (provider.shouldReloadWorkspace(widget.id)) {
      setState(() {
        _workspaceFuture = _fetchWorkspace();
      });
    }
  }

  List<NavigationItem> _getDestinationsByRole(WorkRole? role) {
    final allDestinations = [
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
    ];

    // Si el rol es visitor o no existe, solo mostrar medidores
    if (role == WorkRole.visitor || role == null) {
      return [allDestinations.first];
    }

    // Si el rol es administrator u owner, mostrar todas las secciones
    if (role == WorkRole.administrator || role == WorkRole.owner) {
      return allDestinations;
    }

    // Por defecto, solo mostrar medidores
    return [allDestinations.first];
  }

  List<RouteProperties> _getRoutesByRole(WorkRole? role) {
    final allRoutes = [
      Routes.workspace,
      Routes.alerts,
      Routes.guests,
      Routes.locationMeters,
      Routes.updateWorkspace,
    ];

    if (role == WorkRole.visitor || role == null) {
      return [allRoutes.first];
    }

    if (role == WorkRole.administrator || role == WorkRole.owner) {
      return allRoutes;
    }

    return [allRoutes.first];
  }

  void _onDestinationSelected(int index, WorkRole? role) {
    final routes = _getRoutesByRole(role);
    if (index >= routes.length) return;

    context.goNamed(
      routes[index].name,
      pathParameters: {"id": widget.id},
    );

    if (currentIndex != index) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<Workspace>>(
      future: _workspaceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LayoutSkeleton();
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            !snapshot.data!.isSuccess) {
          return const ErrorPage();
        }

        final workspace = snapshot.data!.value;
        final destinations = _getDestinationsByRole(workspace?.role);

        return Layout(
          title: workspace?.name ?? "Espacio no encontrado",
          selectedIndex: currentIndex,
          onDestinationSelected: (index) =>
              _onDestinationSelected(index, workspace?.role),
          destinations: destinations,
          builder: widget.builder,
        );
      },
    );
  }
}
