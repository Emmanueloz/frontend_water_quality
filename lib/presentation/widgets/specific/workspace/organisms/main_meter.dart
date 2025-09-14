import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/storage_key.dart';
import 'package:frontend_water_quality/infrastructure/connectivity_provider.dart';
import 'package:frontend_water_quality/infrastructure/local_storage_service.dart';
import 'package:frontend_water_quality/presentation/widgets/common/organisms/resizable_container.dart';
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

  int count = 0;

  bool _resizable = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isOffline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOffline;

    if (isOffline) {
      print("is offline");
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
    String? recordString =
        await LocalStorageService.get(StorageKey.lastRecords);

    print(recordString);

    if (recordString != null) {
      setState(() {
        lastRecord = RecordResponse.fromString(recordString);
      });
    }
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

        return _buildMain(context, record ?? lastRecord);
      },
    );
  }

  void _saveRecord(RecordResponse? record) {
    if (count != 10) {
      count++;
      return;
    }

    String? recordString = record!.toJsonEncode();

    LocalStorageService.save(StorageKey.lastRecords, recordString);
    count = 0;
  }

  Widget _buildMain(BuildContext context, RecordResponse? record) {
    final meterSize = _getMeterSize();

    _saveRecord(record);

    // Aquí debes mapear los datos recibidos a los valores de los medidores
    // Ejemplo de cómo podrías hacerlo:
    final temperature =
        record?.temperature.value ?? 0; // Valor por defecto si no está presente
    final ph = record?.ph.value ?? 0;
    final tds = record?.tds.value ?? 0;
    final conductivity = record?.conductivity.value ?? 0;
    final turbidity = record?.turbidity.value ?? 0;
    final SRColorValue color =
        record?.color.value ?? SRColorValue(r: 111, g: 111, b: 111);

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
        interval: 5,
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
        sensorType: "TDS",
        value: tds,
        min: 0,
        max: 500,
        interval: 50,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Conductividad",
        value: conductivity,
        min: 0,
        max: 3000,
        interval: 300,
        size: meterSize,
      ),
      RadialGaugeMeter(
        sensorType: "Turbidez",
        value: turbidity,
        min: 0,
        max: 50,
        interval: 5,
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
          alignment: Alignment.topCenter,
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
