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
    final List<DateTime> titles =[ ];
    final List<FlSpot> values = [];
    final int length = data.averages!.length;

    for (int i = 0; i < length; i++) {
      final avg = data.averages?[i];
      titles.add(avg!.date ?? DateTime.now());
      values.add(
        FlSpot(i.toDouble(), avg.value ?? 0),
      );
    }

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
                  name.toUpperCase(),
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          color: theme.colorScheme.primary,
                          spots: values,
                        )
                      ],
                      gridData: FlGridData(drawVerticalLine: false),
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

  String _formatDate(DateTime datetime) {
    String format = "dd/MM";

    if (periodType == "months") {
      format = "MM";
    } else if (periodType == "years") {
      format = "yyyy";
    }

    print(format);

    return DateFormat(format).format(
      datetime,
    );
  }

  double _getInterval(int length) {
    if (length > 15) {
      return 2;
    }
    return 1;
  }
}
