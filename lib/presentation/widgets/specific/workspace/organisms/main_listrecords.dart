import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/line_graph.dart';

/// Widget principal para listado de registros del medidor.
/// Versión mejorada con funcionalidad completa.
class MainListrecords extends StatelessWidget {
  final String id;
  final String idMeter;
  final ScreenSize screenSize;

  const MainListrecords({
    super.key,
    required this.idMeter,
    required this.screenSize,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    // Simplemente retornar el contenido, el LayoutMeters se encarga del Expanded
    return _buildMain(context);
  }

  Widget _buildMain(BuildContext context) {
    EdgeInsetsGeometry margin;
    EdgeInsetsGeometry padding;
    int crossAxisCount;
    double childAspectRatio;

    if (screenSize == ScreenSize.smallDesktop) {
      margin = const EdgeInsets.all(0);
      padding = const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 9,
      );
      crossAxisCount = 3;
      childAspectRatio = 1 / 1.2;
    } else if (screenSize == ScreenSize.largeDesktop) {
      margin = const EdgeInsets.all(0);
      padding = const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 9,
      );
      crossAxisCount = 3;
      childAspectRatio = 1 / 0.70;
    } else if (screenSize == ScreenSize.tablet) {
      margin = const EdgeInsets.all(10);
      padding = const EdgeInsets.all(12.0);
      crossAxisCount = 2;
      childAspectRatio = 1 / 1.2;
    } else {
      // Mobile
      margin = const EdgeInsets.all(10);
      padding = const EdgeInsets.all(10.0);
      crossAxisCount = 1;
      childAspectRatio = 1 / 1.2;
    }

    // Lista de gráficos de ejemplo (puedes modificarla para pruebas)
    final List<Widget> linegraphs = [
      LineGraph(
        sensorType: "Temperatura",
        value: 22.5,
        dates: ["27/05", "28/05", "29/05", "30/05", "31/05"],
        data: [21.0, 21.5, 22.0, 23.0, 22.5],
        minY: 20.0,
        maxY: 25.0,
        intervalY: 1.0,
      ),
      LineGraph(
        sensorType: "PH",
        value: 7.2,
        dates: ["27/05", "28/05", "29/05", "30/05", "31/05"],
        data: [6.8, 7.0, 7.1, 7.3, 7.2],
        minY: 6.5,
        maxY: 7.5,
        intervalY: 0.5,
      ),
      LineGraph(
        sensorType: "Total de sólidos disueltos",
        value: 300,
        dates: ["27/05", "28/05", "29/05", "30/05", "31/05"],
        data: [280, 290, 310, 320, 300],
        minY: 250,
        maxY: 350,
        intervalY: 10,
      ),
      LineGraph(
        sensorType: "Conductividad",
        value: 1500,
        dates: ["27/05", "28/05", "29/05", "30/05", "31/05"],
        data: [1400, 1450, 1480, 1520, 1500],
        minY: 1300,
        maxY: 1600,
        intervalY: 50,
      ),
      LineGraph(
        sensorType: "Turbidez",
        value: 2.5,
        dates: ["27/05", "28/05", "29/05", "30/05", "31/05"],
        data: [1.8, 2.0, 2.1, 2.3, 2.5],
        minY: 1.0,
        maxY: 3.0,
        intervalY: 0.5,
      ),
    ];

    return BaseContainer(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título principal
          Text(
            "Historial del medidor $idMeter",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Contenedor con scroll para los gráficos
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: GridView.count(
                childAspectRatio: childAspectRatio,
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: linegraphs,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
