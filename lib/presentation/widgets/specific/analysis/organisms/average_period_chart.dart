import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_sensor.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/line_chart_analysis.dart';

class AveragePeriodChart extends StatelessWidget {
  final SensorType name;
  final DataAvgSensor data;
  final String periodType;
  final double? width;
  final double? maxY;
  final ScreenSize screenSize;

  const AveragePeriodChart({
    super.key,
    required this.name,
    required this.data,
    required this.periodType,
    this.width,
    this.maxY,
    required this.screenSize,
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
      values.add(avg.value ?? 0);
    }

    return LineChartAnalysis(
      title: name.nameSpanish,
      titles: titles,
      values: values,
      periodType: periodType,
      maxY: maxY ?? 0,
      width: width,
      screenSize: screenSize,
    );
  }
}
