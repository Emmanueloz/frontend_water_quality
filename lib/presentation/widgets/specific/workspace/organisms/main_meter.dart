import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/limit_chart_sensor.dart';
import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import 'package:frontend_water_quality/infrastructure/connectivity_provider.dart';
import 'package:frontend_water_quality/infrastructure/record_storage.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/resizable_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/data_indicator.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/button_actions.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/radial_gauge_meter.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/sensor_color.dart';
import 'package:frontend_water_quality/presentation/providers/meter_record_provider.dart';
import 'package:frontend_water_quality/domain/models/record_models.dart';

class MainMeter extends StatefulWidget {
  final String id;
  final String idMeter;
  final ScreenSize screenSize;
  final bool isFullScreen;

  const MainMeter({
    super.key,
    required this.idMeter,
    required this.screenSize,
    required this.id,
    this.isFullScreen = false,
  });

  @override
  State<MainMeter> createState() => _MainMeterState();
}

class _MainMeterState extends State<MainMeter> {
  MeterRecordProvider? _meterProvider; // Referencia guardada del provider
  final String baseUrl = 'https://api.aqua-minds.org';

  RecordResponse lastRecord = RecordResponse.empty;

  bool _resizable = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isOffline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOffline;

    if (isOffline) {
      //print("is offline");
      return;
    }
    _meterProvider = Provider.of<MeterRecordProvider>(context, listen: false);
    _meterProvider!.subscribeToMeter(
      baseUrl: baseUrl,
      idWorkspace: widget.id,
      idMeter: widget.idMeter,
    );
  }

  @override
  void initState() {
    super.initState();

    _getLastRecord();
  }

  Future<void> _getLastRecord() async {
    String? recordString = await RecordStorage.get(widget.idMeter);

    if (recordString != null) {
      setState(() {
        lastRecord = RecordResponse.fromString(recordString);
      });
    } else {
      setState(() {
        lastRecord = RecordResponse.empty;
      });
    }
  }

  @override
  void dispose() {
    // Usar la referencia guardada en lugar de acceder al Provider
    _meterProvider?.unsubscribe();
    lastRecord = RecordResponse.empty;
    _meterProvider?.clean();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterRecordProvider>(
      builder: (context, meterProvider, _) {
        final record = meterProvider.recordResponse;
        final isLive = meterProvider.recordResponse != null;
        if (meterProvider.errorMessageSocket != null) {
          return BaseContainer(
            margin: _getMargin(),
            child: Center(
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(meterProvider.errorMessageSocket!),
                  ElevatedButton(
                    onPressed: () => meterProvider.subscribeToMeter(
                      baseUrl: baseUrl,
                      idWorkspace: widget.id,
                      idMeter: widget.idMeter,
                    ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildMain(context, record ?? lastRecord, isLive, record);
      },
    );
  }

  void _saveRecord(RecordResponse? record) {
    if (record == null) return;
    String recordString = record.toJsonEncode();
    RecordStorage.save(widget.idMeter, recordString);
  }

  Widget _buildMain(BuildContext context, RecordResponse? record, bool isLive,
      RecordResponse? liveRecord) {
    final meterSize = _getMeterSize();

    // Solo guardar si hay un nuevo registro del socket (isLive)
    if (isLive && liveRecord != null) {
      _saveRecord(liveRecord);
    }

    final temperature =
        record?.temperature.value ?? 0; // Valor por defecto si no está presente
    final ph = record?.ph.value ?? 0;
    final tds = record?.tds.value ?? 0;
    final conductivity = record?.conductivity.value ?? 0;
    final turbidity = record?.turbidity.value ?? 0;
    final SRColorValue color =
        record?.color.value ?? SRColorValue(r: 111, g: 111, b: 111);

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
        max: LimitChartSensor.getMaxY(SensorType.temperature),
        interval: 5,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "PH",
        value: ph,
        min: 0,
        max: LimitChartSensor.getMaxY(SensorType.ph),
        interval: 1,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Total de Sólidos Disueltos",
        value: tds,
        min: 0,
        max: LimitChartSensor.getMaxY(SensorType.tds),
        interval: 100,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Conductividad",
        value: conductivity,
        min: 0,
        max: LimitChartSensor.getMaxY(SensorType.conductivity),
        interval: 100,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Turbidez",
        value: turbidity,
        min: 0,
        max: LimitChartSensor.getMaxY(SensorType.turbidity),
        interval: 50,
        size: meterSize,
      ),
    ];

    return Hero(
      tag: "main_meter",
      flightShuttleBuilder: (context, animation, flightDirection,
          fromHeroContext, toHeroContext) {
        return Material(
          child: toHeroContext.widget,
        );
      },
      child: BaseContainer(
        width: double.infinity,
        margin: _getMargin(),
        padding: _getPadding(),
        child: Align(
          alignment: Alignment.center,
          child: ResizableContainer(
            resizable: _resizable,
            width: ScreenSize.smallDesktop == widget.screenSize ||
                    ScreenSize.largeDesktop == widget.screenSize
                ? 1200
                : double.infinity,
            height: ScreenSize.smallDesktop == widget.screenSize ||
                    ScreenSize.largeDesktop == widget.screenSize
                ? 700
                : double.infinity,
            minWidth: ScreenSize.largeDesktop == widget.screenSize ? 900 : 600,
            minHeight: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ButtonActions(
                  title: Text(
                    "Monitoreo",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    // Indicador de recibido de datos (primer elemento)
                    // Si isLive==true, el indicador pulsa en cada rebuild; si false, aparece apagado (gris).
                    DataIndicator(active: isLive),
                    // Acciones de pantalla completa / resizable
                    if (widget.screenSize == ScreenSize.largeDesktop ||
                        widget.screenSize == ScreenSize.smallDesktop)
                      if (_resizable)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _resizable = false;
                            });
                          },
                          icon: Icon(Icons.close_fullscreen),
                        )
                      else
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _resizable = true;
                            });
                          },
                          icon: Icon(Icons.open_in_full_sharp),
                        ),
                    if (widget.isFullScreen)
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(Icons.fullscreen_exit),
                      )
                    else
                      IconButton(
                        onPressed: () {
                          print("Full Screen ");
                          context.goNamed(
                            Routes.meterFullscreen.name,
                            pathParameters: {
                              "id": widget.id,
                              "idMeter": widget.idMeter,
                            },
                          );
                        },
                        icon: Icon(Icons.fullscreen),
                      )
                  ],
                  screenSize: widget.screenSize,
                ),
                Expanded(
                  child: GridView.count(
                    childAspectRatio: _getChildAspectRatio(),
                    crossAxisCount: _getCrossAxisCount(),
                    crossAxisSpacing: 10,
                    children: meters,
                  ),
                ),
              ],
            ),
          ),
        ),
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

  EdgeInsets _getPadding() {
    switch (widget.screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(10);
      case ScreenSize.tablet:
        return const EdgeInsets.all(12);
      default:
        return const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 2,
        );
    }
  }

  int _getCrossAxisCount() {
    switch (widget.screenSize) {
      case ScreenSize.mobile:
        return 1;
      case ScreenSize.tablet:
        return 2;
      default:
        return 3;
    }
  }

  double _getChildAspectRatio() {
    switch (widget.screenSize) {
      case ScreenSize.largeDesktop:
        return 1 / 0.70;
      default:
        return 0.8 / 0.8;
    }
  }

  Size _getMeterSize() {
    switch (widget.screenSize) {
      case ScreenSize.mobile:
        return const Size(340, 260);
      case ScreenSize.tablet:
        return const Size(300, 240);
      case ScreenSize.smallDesktop:
        return const Size(300, 180);
      case ScreenSize.largeDesktop:
        return const Size(300, 190);
    }
  }
}
