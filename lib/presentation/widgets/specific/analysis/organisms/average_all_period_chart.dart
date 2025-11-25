import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/constants/limit_chart_sensor.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/enums/sensor_type.dart';
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
    final double width = 600;

    return Container(
      padding: EdgeInsets.all(20),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          LineChartAnalysis(
            title: SensorType.conductivity.nameSpanish,
            titles: data.conductivity!.labels ?? [],
            values: data.conductivity!.values ?? [],
            periodType: periodType,
            maxY: LimitChartSensor.getMaxY(SensorType.conductivity),
            width: width,
            screenSize: screenSize,
          ),
          LineChartAnalysis(
            title: SensorType.ph.nameSpanish,
            titles: data.ph!.labels ?? [],
            values: data.ph!.values ?? [],
            periodType: periodType,
            maxY: LimitChartSensor.getMaxY(SensorType.ph),
            width: width,
            screenSize: screenSize,
          ),
          LineChartAnalysis(
            title: SensorType.tds.nameSpanish,
            titles: data.tds!.labels ?? [],
            values: data.tds!.values ?? [],
            periodType: periodType,
            maxY: LimitChartSensor.getMaxY(SensorType.tds),
            width: width,
            screenSize: screenSize,
          ),
          LineChartAnalysis(
            title: SensorType.temperature.nameSpanish,
            titles: data.temperature!.labels ?? [],
            values: data.temperature!.values ?? [],
            periodType: periodType,
            maxY: LimitChartSensor.getMaxY(SensorType.temperature),
            width: width,
            screenSize: screenSize,
          ),
          LineChartAnalysis(
            title: SensorType.turbidity.nameSpanish,
            titles: data.turbidity!.labels ?? [],
            values: data.turbidity!.values ?? [],
            periodType: periodType,
            maxY: LimitChartSensor.getMaxY(SensorType.turbidity),
            width: width,
            screenSize: screenSize,
          ),
        ],
      ),
    );
  }
}
