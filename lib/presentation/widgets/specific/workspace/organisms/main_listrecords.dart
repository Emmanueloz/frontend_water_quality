import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/meter_records_response.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/line_graph.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_provider.dart';

/// Widget principal para listado de registros del medidor.
/// Versión mejorada con funcionalidad completa.
class MainListrecords extends StatefulWidget {
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
  State<MainListrecords> createState() => _MainListrecordsState();
}

class _MainListrecordsState extends State<MainListrecords> {
  MeterProvider? _meterProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _meterProvider = Provider.of<MeterProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    // Cargar registros cuando se inicializa la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_meterProvider != null) {
        _meterProvider!.fetchMeterRecords(widget.id, widget.idMeter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterProvider>(
      builder: (context, meterProvider, _) {
        if (meterProvider.isLoading) {
          return BaseContainer(
              child: const Center(child: CircularProgressIndicator()));
        }

        if (meterProvider.errorMessage != null) {
          return BaseContainer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error al cargar los registros',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(meterProvider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => meterProvider.fetchMeterRecords(
                        widget.id, widget.idMeter),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final MeterRecordsResponse? records =
            meterProvider.meterRecordsResponse;
        if (records == null) {
          return const Center(child: Text('No hay registros disponibles'));
        }

        return _buildMain(context, records);
      },
    );
  }

  Widget _buildMain(BuildContext context, MeterRecordsResponse records) {
    EdgeInsetsGeometry margin;
    EdgeInsetsGeometry padding;
    int crossAxisCount;
    double childAspectRatio;

    if (widget.screenSize == ScreenSize.smallDesktop) {
      margin = const EdgeInsets.all(0);
      padding = const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 9,
      );
      crossAxisCount = 2;
      childAspectRatio = 1 / 0.8;
    } else if (widget.screenSize == ScreenSize.largeDesktop) {
      margin = const EdgeInsets.all(0);
      padding = const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 9,
      );
      crossAxisCount = 3;
      childAspectRatio = 1 / 0.6;
    } else if (widget.screenSize == ScreenSize.tablet) {
      margin = const EdgeInsets.all(10);
      padding = const EdgeInsets.all(12.0);
      crossAxisCount = 2;
      childAspectRatio = 1 / 0.8;
    } else {
      // Mobile
      margin = const EdgeInsets.all(10);
      padding = const EdgeInsets.all(10.0);
      crossAxisCount = 1;
      childAspectRatio = 1 / 0.8;
    }

    // Mapear los datos de registros a los gráficos
    final List<Widget> linegraphs = _buildLineGraphs(records);

    return BaseContainer(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y botón de recarga
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Historial del medidor ${widget.idMeter}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Consumer<MeterProvider>(
                builder: (context, meterProvider, _) {
                  return IconButton(
                    onPressed: meterProvider.isLoading
                        ? null
                        : () => meterProvider.refreshMeterRecords(),
                    icon: meterProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    tooltip: 'Recargar registros',
                  );
                },
              ),
            ],
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

  List<Widget> _buildLineGraphs(records) {
    return [
      _buildTemperatureGraph(records),
      _buildPhGraph(records),
      _buildTdsGraph(records),
      _buildConductivityGraph(records),
      _buildTurbidityGraph(records),
    ];
  }

  Widget _buildTemperatureGraph(records) {
    final temperatureRecords = records.temperatureRecords;
    if (temperatureRecords.isEmpty) {
      return _buildEmptyGraph("Temperatura");
    }

    final dates = temperatureRecords
        .map((r) => _formatDate(r.datetime))
        .toList()
        .cast<String>();
    final data = temperatureRecords.map((r) => r.value).toList().cast<double>();
    final currentValue = data.isNotEmpty ? data.last : 0.0;
    final minY = 0.0;
    final maxY = 35.0;

    return LineGraph(
      sensorType: "Temperatura",
      value: currentValue,
      dates: dates,
      data: data,
      minY: minY,
      maxY: maxY,
      intervalY: 5.0,
    );
  }

  Widget _buildPhGraph(records) {
    final phRecords = records.phRecords;
    if (phRecords.isEmpty) {
      return _buildEmptyGraph("PH");
    }

    final dates =
        phRecords.map((r) => _formatDate(r.datetime)).toList().cast<String>();
    final data = phRecords.map((r) => r.value).toList().cast<double>();
    final currentValue = data.isNotEmpty ? data.last : 0.0;
    final minY = 0.0;
    final maxY = 10.0;

    return LineGraph(
      sensorType: "PH",
      value: currentValue,
      dates: dates,
      data: data,
      minY: minY,
      maxY: maxY,
      intervalY: 1.0,
    );
  }

  Widget _buildTdsGraph(records) {
    final tdsRecords = records.tdsRecords;
    if (tdsRecords.isEmpty) {
      return _buildEmptyGraph("Total de sólidos disueltos");
    }

    final dates =
        tdsRecords.map((r) => _formatDate(r.datetime)).toList().cast<String>();
    final data = tdsRecords.map((r) => r.value).toList().cast<double>();
    final currentValue = data.isNotEmpty ? data.last : 0.0;
    final minY = 0.0;
    final maxY = 500.0;

    return LineGraph(
      sensorType: "Total de sólidos disueltos",
      value: currentValue,
      dates: dates,
      data: data,
      minY: minY,
      maxY: maxY,
      intervalY: 100.0,
    );
  }

  Widget _buildConductivityGraph(records) {
    final conductivityRecords = records.conductivityRecords;
    if (conductivityRecords.isEmpty) {
      return _buildEmptyGraph("Conductividad");
    }

    final dates = conductivityRecords
        .map((r) => _formatDate(r.datetime))
        .toList()
        .cast<String>();
    final data =
        conductivityRecords.map((r) => r.value).toList().cast<double>();
    final currentValue = data.isNotEmpty ? data.last : 0.0;
    final minY = 0.0;
    final maxY = 3000.0;

    return LineGraph(
      sensorType: "Conductividad",
      value: currentValue,
      dates: dates,
      data: data,
      minY: minY,
      maxY: maxY,
      intervalY: 200.0,
    );
  }

  Widget _buildTurbidityGraph(records) {
    final turbidityRecords = records.turbidityRecords;
    if (turbidityRecords.isEmpty) {
      return _buildEmptyGraph("Turbidez");
    }

    final dates = turbidityRecords
        .map((r) => _formatDate(r.datetime))
        .toList()
        .cast<String>();
    final data = turbidityRecords.map((r) => r.value).toList().cast<double>();
    final currentValue = data.isNotEmpty ? data.last : 0.0;
    final minY = 0.0;
    final maxY = 50.0;

    return LineGraph(
      sensorType: "Turbidez",
      value: currentValue,
      dates: dates,
      data: data,
      minY: minY,
      maxY: maxY,
      intervalY: 5.0,
    );
  }

  Widget _buildEmptyGraph(String sensorType) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              sensorType,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Sin datos disponibles',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {
    final dateTime = DateTime.parse(date);
    // Formatear la fecha al formato dd/mm
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');

    return '$day/$month';
  }
}
