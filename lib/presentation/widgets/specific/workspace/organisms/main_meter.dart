import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/radial_gauge_meter.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/sensor_color.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';
import 'package:frontend_water_quality/presentation/providers/auth_provider.dart';

/// Widget principal para monitoreo de medidor.
/// Versión mejorada con funcionalidad completa.
class MainMeter extends StatefulWidget {
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
  State<MainMeter> createState() => _MainMeterState();
}

class _MainMeterState extends State<MainMeter> {
  @override
  void initState() {
    super.initState();
    // Aquí deberías obtener el token y baseUrl de tu AuthProvider o configuración
    final meterProvider = Provider.of<MeterProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token ?? '';
    // Ajusta el baseUrl según tu configuración
    const baseUrl = 'https://api.aqua-minds.org';
    meterProvider.subscribeToMeter(
      baseUrl: baseUrl,
      token: token,
      idWorkspace: widget.id,
      idMeter: widget.idMeter,
    );
  }

  @override
  void dispose() {
    Provider.of<MeterProvider>(context, listen: false).unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterProvider>(
      builder: (context, meterProvider, _) {
        final data = meterProvider.meterData;
        // Si no hay datos, puedes mostrar un loader o los valores por defecto
        return _buildMain(context, data);
      },
    );
  }

  Widget _buildMain(BuildContext context, dynamic data) {
    EdgeInsetsGeometry margin;
    EdgeInsetsGeometry padding;
    Size meterSize;
    int crossAxisCount;
    double childAspectRatio;

    if (widget.screenSize == ScreenSize.smallDesktop) {
      margin = const EdgeInsets.all(0);
      padding = const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 9,
      );
      meterSize = const Size(300, 180);
      crossAxisCount = 3;
      childAspectRatio = 1 / 1.2;
    } else if (widget.screenSize == ScreenSize.largeDesktop) {
      margin = const EdgeInsets.all(0);
      padding = const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 9,
      );
      meterSize = const Size(300, 190);
      crossAxisCount = 3;
      childAspectRatio = 1 / 0.70;
    } else if (widget.screenSize == ScreenSize.tablet) {
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

    // Aquí debes mapear los datos recibidos a los valores de los medidores
    // Ejemplo de cómo podrías hacerlo:
    final temperatura = data?['temperatura'] ?? 0;
    final ph = data?['ph'] ?? 0;
    final tds = data?['tds'] ?? 0;
    final conductividad = data?['conductividad'] ?? 0;
    final turbidez = data?['turbidez'] ?? 0;

    // Lista de medidores de ejemplo (puedes modificarla para pruebas)
    final List<Widget> meters = [
      SensorColor(
        red: 48,
        green: 120,
        blue: 171,
      ),
      RadialGaugeMeter(
        sensorType: "Temperatura",
        value: temperatura,
        min: 0,
        max: 60,
        interval: 10,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "PH",
        value: ph,
        min: 0,
        max: 14,
        interval: 1,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Total de sólidos disueltos",
        value: tds,
        min: 0,
        max: 10,
        interval: 1,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Conductividad",
        value: conductividad,
        min: 0,
        max: 1000,
        interval: 100,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Turbidez",
        value: turbidez,
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
              "Meter ${widget.idMeter}",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
            ],
            screenSize: widget.screenSize,
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
