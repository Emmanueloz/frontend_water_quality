import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_all.dart';

class AverageAllPeriodChart extends StatelessWidget {
  final ScreenSize screenSize;
  final DataAvgAll data;
  const AverageAllPeriodChart({
    super.key,
    required this.screenSize,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: _buildChart(),
      ),
    );
  }

  List<Widget> _buildChart() {
    return [];
  }
}
