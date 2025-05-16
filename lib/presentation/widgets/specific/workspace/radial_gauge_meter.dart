import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class RadialGaugeMeter extends StatelessWidget {
  final String sensorType;
  final double value;
  final double min;
  final double max;
  final int interval;
  final Size size;

  const RadialGaugeMeter({
    super.key,
    required this.sensorType,
    required this.value,
    required this.min,
    required this.max,
    this.interval = 10,
    this.size = const Size(300, 300),
  });

  @override
  Widget build(BuildContext context) {
    final double valueValid = value > min && value < max ? value : min;

    return Column(
      children: [
        Text(sensorType),
        const SizedBox(height: 20),
        GxRadialGauge(
          showValueAtCenter: false,
          size: size,
          startAngleInDegree: 180,
          sweepAngleInDegree: 180,
          value: GaugeValue(
            value: valueValid,
            min: min,
            max: max,
          ),
          interval: interval,
          showNeedle: true,
          showLabels: true,
          showMajorTicks: true,
          labelTickStyle: RadialTickLabelStyle(
            position: RadialElementPosition.outside,
            padding: 10,
          ),
          majorTickStyle: RadialTickStyle(
            color: Colors.cyan,
            position: RadialElementPosition.outside,
            length: 10,
            thickness: 1,
          ),
          style: RadialGaugeStyle(
            color: Colors.white,
            thickness: 10,
            gradient: LinearGradient(
              colors: [
                Colors.cyan.shade300,
                Colors.cyan.shade600,
                Colors.cyan.shade900,
              ],
            ),
          ),
          needle: RadialNeedle(
            color: Colors.cyan,
            shape: RadialNeedleShape.tapperedLine,
            alignment: RadialElementAlignment.end,
            thickness: 12,
            topOffest: -20,
          ),
        ),
      ],
    );
  }
}
