import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/core/enums/sensor_type.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/data_pred_all.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/line_chart_prediction.dart';

class PredictionAllChart extends StatelessWidget {
  final DataPredAll data;
  final String periodType;
  final ScreenSize screenSize;
  const PredictionAllChart({
    super.key,
    required this.data,
    required this.periodType,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    final double width = 600;

    final titles = [...?data.data?.labels, ...?data.pred!.labels];

    return Container(
      padding: EdgeInsets.all(20),
      child: Wrap(
        children: [
          LineChartPrediction(
            width: width,
            sensor: SensorType.conductivity,
            titles: titles,
            periodType: periodType,
            dataValues: data.data?.conductivity ?? [],
            predValues: data.pred?.conductivity ?? [],
            screenSize: screenSize,
          ),
          LineChartPrediction(
            width: width,
            sensor: SensorType.ph,
            titles: titles,
            periodType: periodType,
            dataValues: data.data?.ph ?? [],
            predValues: data.pred?.ph ?? [],
            screenSize: screenSize,
          ),
          LineChartPrediction(
            width: width,
            sensor: SensorType.tds,
            titles: titles,
            periodType: periodType,
            dataValues: data.data?.tds ?? [],
            predValues: data.pred?.tds ?? [],
            screenSize: screenSize,
          ),
          LineChartPrediction(
            width: width,
            sensor: SensorType.temperature,
            titles: titles,
            periodType: periodType,
            dataValues: data.data?.temperature ?? [],
            predValues: data.pred?.temperature ?? [],
            screenSize: screenSize,
          ),
          LineChartPrediction(
            width: width,
            sensor: SensorType.turbidity,
            titles: titles,
            periodType: periodType,
            dataValues: data.data?.turbidity ?? [],
            predValues: data.pred?.turbidity ?? [],
            screenSize: screenSize,
          ),
        ],
      ),
    );
  }
}
