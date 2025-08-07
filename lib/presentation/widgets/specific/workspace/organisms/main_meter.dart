import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/radial_gauge_meter.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/sensor_color.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_record_provider.dart';
import 'package:frontend_water_quality/domain/models/record_models.dart';

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
  MeterRecordProvider? _meterProvider; // Referencia guardada del provider
  final String baseUrl = 'https://api.aqua-minds.org';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _meterProvider = Provider.of<MeterRecordProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    // Nota: No podemos acceder al Provider aquí porque didChangeDependencies
    // aún no se ha ejecutado. Movemos la suscripción a didChangeDependencies
    // o usamos un WidgetsBinding.instance.addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_meterProvider != null) {
        _meterProvider!.subscribeToMeter(
          baseUrl: baseUrl,
          idWorkspace: widget.id,
          idMeter: widget.idMeter,
        );
      }
    });
  }

  @override
  void dispose() {
    // Usar la referencia guardada en lugar de acceder al Provider
    _meterProvider?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterRecordProvider>(
      builder: (context, meterProvider, _) {
        final record = meterProvider.recordResponse;
        if (meterProvider.errorMessageSocket != null) {
          return BaseContainer(
              margin: _getMargin(),
              child: Center(child: Text(meterProvider.errorMessageSocket!)));
        }
        // if (record == null) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        return _buildMain(context, record);
      },
    );
  }

  Widget _buildMain(BuildContext context, RecordResponse? record) {
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
    final temperature =
        record?.temperature.value ?? 0; // Valor por defecto si no está presente
    final ph = record?.ph.value ?? 0;
    final tds = record?.tds.value ?? 0;
    final conductivity = record?.conductivity.value ?? 0;
    final turbidity = record?.turbidity.value ?? 0;
    final SRColorValue color = record?.color.value ??
        SRColorValue(r: 111, g: 111, b: 111); // Color por defecto

    // Lista de medidores de ejemplo (puedes modificarla para pruebas)
    final List<Widget> meters = [
      SensorColor(
        red: color.r,
        green: color.g,
        blue: color.b,
      ),
      RadialGaugeMeter(
        sensorType: "Temperatura",
        value: temperature,
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
        value: conductivity,
        min: 0,
        max: 1000,
        interval: 100,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Turbidez",
        value: turbidity,
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
            actions: [],
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

  EdgeInsets _getMargin() {
    switch (widget.screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(10);
      case ScreenSize.tablet:
        return const EdgeInsets.all(10);
      case ScreenSize.smallDesktop:
        return const EdgeInsets.all(0);
      case ScreenSize.largeDesktop:
        return const EdgeInsets.all(0);
    }
  }
}
