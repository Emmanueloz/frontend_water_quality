import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_sensor.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/line_chart_analysis.dart';

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
    final List<DateTime> titles = [];
    final List<double?> values = [];
    final int length = data.averages!.length;

    // Crear títulos para el eje X
    for (int i = 0; i < length; i++) {
      final avg = data.averages?[i];
      titles.add(avg!.date ?? DateTime.now());
      values.add(avg.value);
    }

    return LineChartAnalysis(
      title: name,
      titles: titles,
      values: values,
      periodType: periodType,
      maxY: maxY ?? 0,
      width: width,
    );
  }
}
