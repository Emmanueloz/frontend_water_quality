import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AverageChart extends StatelessWidget {
  final double average;
  final double min;
  final double max;
  final double maxY;
  final String name;
  final double? width;

  const AverageChart({
    super.key,
    required this.average,
    required this.min,
    required this.max,
    required this.maxY,
    required this.name,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                Text(
                  name.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: min,
                              width: 30,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: average,
                              width: 30,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              toY: max > maxY ? maxY : max,
                              width: 30,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        )
                      ],
                      gridData: FlGridData(
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 30,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final tiles = ["min", "promedio", "max"];
                              final Widget text = Text(
                                tiles[value.toInt()],
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              );
                              return SideTitleWidget(
                                meta: meta,
                                child: text,
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
