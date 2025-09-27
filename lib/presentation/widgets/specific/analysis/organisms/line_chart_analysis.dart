import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class LineChartAnalysis extends StatelessWidget {
  final String title;
  final List<DateTime?> titles;
  final List<double?> values;
  final String periodType;
  final double maxY;
  final double? width;

  const LineChartAnalysis({
    super.key,
    required this.title,
    required this.titles,
    required this.values,
    required this.periodType,
    required this.maxY,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final length = values.length;

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
                  "${title.toUpperCase()} - Cantidad de valores $length",
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
                                  _formatDate(titles[index] ?? DateTime.now()),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 45,
                            interval: _getIntervalX(),
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

    for (int i = 0; i < values.length; i++) {
      final value = values[i];

      if (value != null) {
        currentSegment.add(FlSpot(i.toDouble(), value));
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

  double _getIntervalX() {
    if (maxY < 20) {
      return 1;
    }
    return maxY / 10;
  }

  double _getInterval(int length) {
    if (length < 10) {
      return 1;
    }
    return length / 10;
  }
}
