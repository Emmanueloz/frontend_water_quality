import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/limit_chart_sensor.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import 'package:frontend_water_quality/domain/models/meter_records_response.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/line_graph.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/date_range_filter.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_record_provider.dart';

/// Configuration class for sensor display properties
class SensorConfig {
  final String name;
  final String unit;
  final double minY;
  final double maxY;
  final double intervalY;
  final double minThreshold;
  final double maxThreshold;

  const SensorConfig({
    required this.name,
    required this.unit,
    required this.minY,
    required this.maxY,
    required this.intervalY,
    required this.minThreshold,
    required this.maxThreshold,
  });
}

/// Sensor configuration constants with measurement units and thresholds
Map<String, SensorConfig> sensorConfigs = {
  'temperature': SensorConfig(
    name: 'Temperatura',
    unit: '°C',
    minY: 0,
    maxY: LimitChartSensor.getMaxY(SensorType.temperature),
    intervalY: 10,
    minThreshold: 10,
    maxThreshold: 35,
  ),
  'ph': SensorConfig(
    name: 'PH',
    unit: 'pH',
    minY: 0,
    maxY: LimitChartSensor.getMaxY(SensorType.ph),
    intervalY: 2,
    minThreshold: 6.5,
    maxThreshold: 8.5,
  ),
  'tds': SensorConfig(
    name: 'Total de Sólidos Disueltos',
    unit: 'ppm',
    minY: 0,
    maxY: LimitChartSensor.getMaxY(SensorType.tds),
    intervalY: 100,
    minThreshold: 300,
    maxThreshold: 490,
  ),
  'conductivity': SensorConfig(
    name: 'Conductividad',
    unit: 'µS/cm',
    minY: 0,
    maxY: LimitChartSensor.getMaxY(SensorType.conductivity),
    intervalY: 100,
    minThreshold: 0,
    maxThreshold: 1000,
  ),
  'turbidity': SensorConfig(
    name: 'Turbidez',
    unit: 'NTU',
    minY: -50,
    maxY: LimitChartSensor.getMaxY(SensorType.turbidity),
    intervalY: 50,
    minThreshold: 0,
    maxThreshold: 5,
  ),
};

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
  MeterRecordProvider? _meterProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _meterProvider = Provider.of<MeterRecordProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _meterProvider?.fetchMeterRecords(widget.id, widget.idMeter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterRecordProvider>(
      builder: (context, meterProvider, _) {
        if (meterProvider.isLoading &&
            meterProvider.meterRecordsResponse == null) {
          return BaseContainer(
            margin: _getMargin(),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (meterProvider.errorMessageRecords != null &&
            meterProvider.meterRecordsResponse == null) {
          return BaseContainer(
            margin: _getMargin(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error al cargar los registros',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(meterProvider.errorMessageRecords!),
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
          return _buildEmptyState(context, meterProvider);
        }

        return _buildMain(context, records, meterProvider);
      },
    );
  }

  Widget _buildEmptyState(
      BuildContext context, MeterRecordProvider meterProvider) {
    return BaseContainer(
      margin: _getMargin(),
      padding: _getPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, meterProvider),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DateRangeFilter(
                  startDate: meterProvider.currentStartDate,
                  endDate: meterProvider.currentEndDate,
                  isLoading: meterProvider.isLoading,
                  onApplyFilters: meterProvider.applyDateFilters,
                  onPreviousPeriod: meterProvider.hasPreviousPage
                      ? meterProvider.goToPreviousPage
                      : null,
                  onNextPeriod: meterProvider.hasNextPage
                      ? meterProvider.goToNextPage
                      : null,
                  onClear: meterProvider.hasActiveFilters
                      ? meterProvider.clearFilters
                      : null,
                  isMobile: widget.screenSize == ScreenSize.mobile,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text('No hay registros disponibles',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMain(BuildContext context, MeterRecordsResponse records,
      MeterRecordProvider meterProvider) {
    int crossAxisCount = 1;
    double childAspectRatio = 1 / 0.8;

    if (widget.screenSize == ScreenSize.smallDesktop ||
        widget.screenSize == ScreenSize.tablet) {
      crossAxisCount = 2;
    } else if (widget.screenSize == ScreenSize.largeDesktop) {
      crossAxisCount = 2;
      childAspectRatio = 1 / 0.6;
    }

    final List<Widget> linegraphs = [
      _buildGraph(records.temperatureRecords, sensorConfigs['temperature']!),
      _buildGraph(records.phRecords, sensorConfigs['ph']!),
      _buildGraph(records.tdsRecords, sensorConfigs['tds']!),
      _buildGraph(records.conductivityRecords, sensorConfigs['conductivity']!),
      _buildGraph(records.turbidityRecords, sensorConfigs['turbidity']!),
    ];

    return BaseContainer(
      margin: _getMargin(),
      padding: _getPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, meterProvider),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DateRangeFilter(
                  startDate: meterProvider.currentStartDate,
                  endDate: meterProvider.currentEndDate,
                  isLoading: meterProvider.isLoading,
                  onApplyFilters: meterProvider.applyDateFilters,
                  onPreviousPeriod: meterProvider.hasPreviousPage
                      ? meterProvider.goToPreviousPage
                      : null,
                  onNextPeriod: meterProvider.hasNextPage
                      ? meterProvider.goToNextPage
                      : null,
                  onClear: meterProvider.hasActiveFilters
                      ? meterProvider.clearFilters
                      : null,
                  isMobile: widget.screenSize == ScreenSize.mobile,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
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

  Widget _buildGraph(List<dynamic> records, SensorConfig config) {
    if (records.isEmpty) {
      return Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(config.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Sin datos disponibles',
                  style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }

    final dates =
        records.map((r) => _formatDate(r.datetime)).toList().cast<String>();
    final data = records.map((r) => r.value).toList().cast<double>();
    final currentValue =
        data.isNotEmpty ? double.parse(data.last.toStringAsFixed(1)) : 0.0;

    return LineGraph(
      sensorType: config.name,
      value: currentValue,
      dates: dates,
      data: data,
      minY: config.minY,
      maxY: config.maxY,
      intervalY: config.intervalY,
      minThreshold: config.minThreshold,
      maxThreshold: config.maxThreshold,
      unit: config.unit,
    );
  }

  String _formatDate(String date) {
    final dateTime = DateTime.parse(date);
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    return '$day/$month';
  }

  Widget _buildHeader(BuildContext context, MeterRecordProvider meterProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text("Historial del medidor",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
        IconButton(
          onPressed: meterProvider.isLoading
              ? null
              : meterProvider.refreshMeterRecords,
          icon: meterProvider.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.refresh),
          tooltip: 'Recargar registros',
        ),
      ],
    );
  }

  EdgeInsets _getMargin() {
    switch (widget.screenSize) {
      case ScreenSize.mobile:
      case ScreenSize.tablet:
        return const EdgeInsets.all(10);
      case ScreenSize.smallDesktop:
      case ScreenSize.largeDesktop:
        return const EdgeInsets.all(0);
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(10.0);
      case ScreenSize.tablet:
        return const EdgeInsets.all(12.0);
      case ScreenSize.smallDesktop:
      case ScreenSize.largeDesktop:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 9);
    }
  }
}
