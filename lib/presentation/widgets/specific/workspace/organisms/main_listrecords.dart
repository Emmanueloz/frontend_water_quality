import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/meter_records_response.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/molecules/line_graph.dart';
import 'package:frontend_water_quality/presentation/widgets/common/molecules/date_range_filter.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/meter_record_provider.dart';

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
                ),
              ),
              if (meterProvider.hasActiveFilters)
                IconButton(
                  onPressed: meterProvider.clearFilters,
                  icon: const Icon(Icons.clear),
                  tooltip: 'Quitar filtros',
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
      _buildGraph(records.temperatureRecords, "Temperatura", 0, 60, 10, 10, 35),
      _buildGraph(records.phRecords, "PH", 0, 14, 2, 6.5, 8.5),
      _buildGraph(records.tdsRecords, "Total de sólidos disueltos", 0, 1400,
          200, 300, 1000),
      _buildGraph(
          records.conductivityRecords, "Conductividad", 0, 1600, 200, 0, 1000),
      _buildGraph(records.turbidityRecords, "Turbidez", 0, 16, 2, 0, 5),
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
                ),
              ),
              if (meterProvider.hasActiveFilters)
                IconButton(
                  onPressed: meterProvider.clearFilters,
                  icon: const Icon(Icons.clear),
                  tooltip: 'Quitar filtros',
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

  Widget _buildGraph(List<dynamic> records, String sensorType, double minY,
      double maxY, double intervalY, double minThreshold, double maxThreshold) {
    if (records.isEmpty) {
      return Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(sensorType,
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
      sensorType: sensorType,
      value: currentValue,
      dates: dates,
      data: data,
      minY: minY,
      maxY: maxY,
      intervalY: intervalY,
      minThreshold: minThreshold,
      maxThreshold: maxThreshold,
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
          child: Text("Historial del medidor ${widget.idMeter}",
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
