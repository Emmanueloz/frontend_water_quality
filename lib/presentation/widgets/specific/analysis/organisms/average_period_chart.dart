import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_sensor.dart';
import 'package:intl/intl.dart';

class AveragePeriodChart extends StatelessWidget {
  final String name;
  final DataAvgSensor data;
  final String periodType;
  final double? width;
  final double? maxY;

  const AveragePeriodChart({
    super.key,
    required this.name,
    required this.data,
    required this.periodType,
    this.width,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<DateTime> titles = [];
    final int length = data.averages!.length;

    // Crear títulos para el eje X
    for (int i = 0; i < length; i++) {
      final avg = data.averages?[i];
      titles.add(avg!.date ?? DateTime.now());
    }

    // Crear segmentos de líneas discontinuas
    final List<LineChartBarData> lineSegments = _createSegmentedLines(theme);

    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                Text(
                  "${name.toUpperCase()} - Cantidad de valores $length",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      maxY: maxY,
                      minY: 0,
                      lineBarsData: lineSegments,
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            interval: _getInterval(length),
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index < 0 || index >= titles.length) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  _formatDate(titles[index]),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: maxY! / 10,
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List<LineChartBarData> _createSegmentedLines(ThemeData theme) {
    List<LineChartBarData> lines = [];
    List<FlSpot> currentSegment = [];

    for (int i = 0; i < data.averages!.length; i++) {
      final avg = data.averages![i];

      if (avg.value != null) {
        currentSegment.add(FlSpot(i.toDouble(), avg.value!));
      } else {
        // Guardar segmento actual si tiene al menos un punto
        if (currentSegment.isNotEmpty) {
          lines.add(LineChartBarData(
            spots: List.from(currentSegment),
            color: theme.colorScheme.primary,
          ));
          currentSegment.clear();
        }
      }
    }

    // Agregar último segmento si existe
    if (currentSegment.isNotEmpty) {
      lines.add(LineChartBarData(
        spots: List.from(currentSegment),
        color: theme.colorScheme.primary,
      ));
    }

    return lines;
  }

  String _formatDate(DateTime datetime) {
    String format = "dd/MMM";
    if (periodType == "months") {
      format = "MMM";
    } else if (periodType == "years") {
      format = "yyyy";
    }
    return DateFormat(format).format(datetime);
  }

  double _getInterval(int length) {
    return length / 10;
  }
}
