import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/enums/work_roles.dart';
import 'package:frontend_water_quality/core/interface/navigation_item.dart';
import 'package:frontend_water_quality/core/interface/result.dart';
import 'package:frontend_water_quality/core/interface/route_properties.dart';
import 'package:frontend_water_quality/domain/models/meter_model.dart';
import 'package:frontend_water_quality/presentation/pages/error_page.dart';
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
  late Future<Result<Meter>> _meterFuture;

  @override
  void initState() {
    super.initState();
    _meterFuture = _fetchMeter();
  }

  Future<Result<Meter>> _fetchMeter() async {
    final provider = Provider.of<MeterProvider>(context, listen: false);
    return await provider.getMeterById(widget.id, widget.idMeter);
  }

  final List<NavigationItem> _baseDestinations = [
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

  final NavigationItem _connectionDestination = NavigationItem(
    label: "Conexión",
    icon: Icons.wifi_tethering_outlined,
    selectedIcon: Icons.wifi_tethering,
  );

  List<NavigationItem> _getDestinationsByRole(WorkRole? role) {
    print(role);
    // Lista base para visitantes
    if (role == WorkRole.visitor || role == null) {
      return _baseDestinations.take(2).toList();
    }

    // Para roles con acceso completo
    if (role == WorkRole.administrator ||
        role == WorkRole.manager ||
        role == WorkRole.owner) {
      var destinations = List<NavigationItem>.from(_baseDestinations);

      // Agregar conexión solo para admin y owner en Android
      if ((role == WorkRole.administrator || role == WorkRole.owner) &&
          defaultTargetPlatform == TargetPlatform.android &&
          !kIsWeb) {
        destinations.add(_connectionDestination);
      }

      return destinations;
    }

    // Por defecto, acceso básico
    return _baseDestinations.take(2).toList();
  }

  List<RouteProperties> _getRoutesByRole(WorkRole? role) {
    final baseRoutes = [
      Routes.meter,
      Routes.listRecords,
      Routes.analysisRecords,
      Routes.weather,
      Routes.updateMeter,
    ];

    if (role == WorkRole.visitor || role == null) {
      return baseRoutes.take(2).toList();
    }

    if (role == WorkRole.administrator ||
        role == WorkRole.manager ||
        role == WorkRole.owner) {
      var routes = List<RouteProperties>.from(baseRoutes);

      if ((role == WorkRole.administrator || role == WorkRole.owner) &&
          defaultTargetPlatform == TargetPlatform.android &&
          !kIsWeb) {
        routes.add(Routes.connectionMeter);
      }

      return routes;
    }

    return baseRoutes.take(2).toList();
  }

  void _onDestinationSelected(int index, WorkRole? role) {
    final routes = _getRoutesByRole(role);
    if (index >= routes.length) return;

    context.goNamed(
      routes[index].name,
      pathParameters: {
        "id": widget.id,
        "idMeter": widget.idMeter,
      },
    );

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<Meter>>(
      future: _meterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LayoutSkeleton();
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data?.message != null) {
          return const ErrorPage();
        }

        final meter = snapshot.data!.value;
        final destinations = _getDestinationsByRole(meter?.role);

        return Layout(
          title: meter?.name ?? "Medidor no encontrado",
          selectedIndex: currentIndex,
          onDestinationSelected: (index) =>
              _onDestinationSelected(index, meter?.role),
          destinations: destinations,
          builder: widget.builder,
        );
      },
    );
  }
}
