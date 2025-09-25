import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/limit_chart_sensor.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_all.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/line_chart_analysis.dart';

class AverageAllPeriodChart extends StatelessWidget {
  final ScreenSize screenSize;
  final DataAvgAll data;
  final String periodType;
  const AverageAllPeriodChart({
    super.key,
    required this.screenSize,
    required this.data,
    required this.periodType,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            LineChartAnalysis(
              title: "CONDUCTIVIDAD",
              titles: data.conductivity!.labels ?? [],
              values: data.conductivity!.values ?? [],
              periodType: periodType,
              maxY: LimitChartSensor.getMaxY("conductivity"),
            ),
            LineChartAnalysis(
              title: "PH",
              titles: data.ph!.labels ?? [],
              values: data.ph!.values ?? [],
              periodType: periodType,
              maxY: LimitChartSensor.getMaxY("ph"),
            ),
            LineChartAnalysis(
              title: "TDS",
              titles: data.tds!.labels ?? [],
              values: data.tds!.values ?? [],
              periodType: periodType,
              maxY: LimitChartSensor.getMaxY("tds"),
            ),
            LineChartAnalysis(
              title: "TEMPERATURA",
              titles: data.temperature!.labels ?? [],
              values: data.temperature!.values ?? [],
              periodType: periodType,
              maxY: LimitChartSensor.getMaxY("temperature"),
            ),
            LineChartAnalysis(
              title: "TURBIDEZ",
              titles: data.turbidity!.labels ?? [],
              values: data.turbidity!.values ?? [],
              periodType: periodType,
              maxY: LimitChartSensor.getMaxY("turbidity"),
            ),
          ],
        ),
      ),
    );
  }
}
