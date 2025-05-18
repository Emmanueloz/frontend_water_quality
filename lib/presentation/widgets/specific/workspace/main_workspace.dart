import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/radial_gauge_meter.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/sensor_color.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class MainWorkspace extends StatelessWidget {
  final String id;
  final String idMeter;
  final ScreenSize screenSize;

  const MainWorkspace({
    super.key,
    required this.idMeter,
    required this.screenSize,
    required this.id,
  });

  List<Widget> _buttonsNavigation(BuildContext context) {
    return [
      ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Agregar"),
      ),
      ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.alarm),
        label: const Text("Alertas"),
      ),
      ElevatedButton.icon(
        onPressed: () {
          context.goNamed(
            Routes.listRecords.name,
            pathParameters: {
              "id": id,
              "idMeter": idMeter,
            },
          );
        },
        icon: const Icon(Icons.history),
        label: const Text("Historial"),
      ),
    ];
  }

  Widget _buildSecondaryNavigation(
    BuildContext context,
  ) {
    List<Widget> children = [
      Text(
        "Medidor $idMeter",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 2,
          runSpacing: 2,
          children: _buttonsNavigation(context),
        ),
      )
    ];

    List<Widget> childrenDesktop = [
      Text(
        "Medidor $idMeter",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 10,
        children: _buttonsNavigation(context),
      ),
    ];

    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: children,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: childrenDesktop,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Configuración del padding y tamaño de los medidores según el tamaño de pantalla
    EdgeInsetsGeometry padding;
    Size meterSize;
    int crossAxisCount;
    double childAspectRatio;

    if (screenSize == ScreenSize.smallDesktop) {
      padding = const EdgeInsets.all(16.0);
      meterSize = const Size(300, 180);
      crossAxisCount = 3;
      childAspectRatio = 1 / 1.2;
    } else if (screenSize == ScreenSize.largeDesktop) {
      padding = const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 16,
      );
      meterSize = const Size(300, 190);
      crossAxisCount = 3;
      childAspectRatio = 1 / 0.70;
    } else if (screenSize == ScreenSize.tablet) {
      padding = const EdgeInsets.all(12.0);
      meterSize = const Size(300, 240);
      crossAxisCount = 2;
      childAspectRatio = 1 / 1.2;
    } else {
      // Mobile
      padding = const EdgeInsets.all(10.0);
      meterSize = const Size(340, 260);
      crossAxisCount = 1;
      childAspectRatio = 1 / 1.2;
    }

    // Lista de medidores de ejemplo
    final List<Widget> meters = [
      //48, 120, 171
      SensorColor(
        red: 48,
        green: 120,
        blue: 171,
      ),
      RadialGaugeMeter(
        sensorType: "Temperatura",
        value: 54,
        min: 0,
        max: 60,
        interval: 10,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "PH",
        value: 2.4,
        min: 0,
        max: 14,
        interval: 1,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Total de sólidos disueltos",
        value: 7.5,
        min: 0,
        max: 10,
        interval: 1,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Conductividad",
        value: 450,
        min: 0,
        max: 1000,
        interval: 100,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Turbidez",
        value: 12,
        min: 0,
        max: 20,
        interval: 2,
        size: meterSize,
      ),
    ];

    return Expanded(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: const Color.fromARGB(179, 211, 211, 211),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecondaryNavigation(context),
            const SizedBox(height: 16),

            // Contenedor con scroll para los medidores
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
                  children: meters,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
