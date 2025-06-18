import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/radial_gauge_meter.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/sensor_color.dart';

class MainMeter extends StatelessWidget {
  final String id;
  final String idMeter;
  final ScreenSize screenSize;

  const MainMeter({
    super.key,
    required this.idMeter,
    required this.screenSize,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    if (screenSize == ScreenSize.smallDesktop ||
        screenSize == ScreenSize.largeDesktop) {
      return Expanded(child: _buildMain(context));
    }

    return _buildMain(context);
  }

  Widget _buildMain(BuildContext context) {
    EdgeInsetsGeometry margin;
    EdgeInsetsGeometry padding;
    Size meterSize;
    int crossAxisCount;
    double childAspectRatio;

    if (screenSize == ScreenSize.smallDesktop) {
      margin = const EdgeInsets.all(0);
      padding = const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 9,
      );
      meterSize = const Size(300, 180);
      crossAxisCount = 3;
      childAspectRatio = 1 / 1.2;
    } else if (screenSize == ScreenSize.largeDesktop) {
      margin = const EdgeInsets.all(0);

      padding = const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 9,
      );
      meterSize = const Size(300, 190);
      crossAxisCount = 3;
      childAspectRatio = 1 / 0.70;
    } else if (screenSize == ScreenSize.tablet) {
      margin = const EdgeInsets.all(10);

      padding = const EdgeInsets.all(12.0);
      meterSize = const Size(300, 240);
      crossAxisCount = 2;
      childAspectRatio = 1 / 1.2;
    } else {
      // Mobile
      margin = const EdgeInsets.all(10);

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

    return BaseContainer(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonActions(
            title: Text(
              "Meter $idMeter",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [],
            screenSize: screenSize,
          ),
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
    );
  }
}
