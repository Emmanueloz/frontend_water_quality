import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/data_pred_all.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/analysis/organisms/line_chart_prediction.dart';

class PredictionAllChart extends StatelessWidget {
  final DataPredAll data;
  final String periodType;
  const PredictionAllChart({
    super.key,
    required this.data,
    required this.periodType,
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
            sensor: "conductivity",
            titles: titles,
            periodType: periodType,
            dataValues: data.data?.conductivity ?? [],
            predValues: data.pred?.conductivity ?? [],
          ),
          LineChartPrediction(
            width: width,
            sensor: "ph",
            titles: titles,
            periodType: periodType,
            dataValues: data.data?.ph ?? [],
            predValues: data.pred?.ph ?? [],
          ),
          LineChartPrediction(
            width: width,
            sensor: "tds",
            titles: titles,
            periodType: periodType,
            dataValues: data.data?.tds ?? [],
            predValues: data.pred?.tds ?? [],
          ),
          LineChartPrediction(
            width: width,
            sensor: "temperature",
            titles: titles,
            periodType: periodType,
            dataValues: data.data?.temperature ?? [],
            predValues: data.pred?.temperature ?? [],
          ),
          LineChartPrediction(
            width: width,
            sensor: "turbidity",
            titles: titles,
            periodType: periodType,
            dataValues: data.data?.turbidity ?? [],
            predValues: data.pred?.turbidity ?? [],
          ),
        ],
      ),
    );
  }
}
