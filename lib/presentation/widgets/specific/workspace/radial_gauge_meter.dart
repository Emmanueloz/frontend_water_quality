import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/workspace/sensor_container.dart';
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

    return SensorContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            sensorType,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: GxRadialGauge(
              showValueAtCenter: false,
              startAngleInDegree: 140,
              sweepAngleInDegree: 260,
              value: GaugeValue(
                value: valueValid,
                min: min,
                max: max,
              ),
              size: size,
              interval: interval,
              showNeedle: true,
              showLabels: true,
              showMajorTicks: true,
              labelTickStyle: const RadialTickLabelStyle(
                position: RadialElementPosition.inside,
                padding: 10,
              ),
              majorTickStyle: RadialTickStyle(
                color: Colors.cyan,
                position: RadialElementPosition.inside,
                length: 8,
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
              needle: const RadialNeedle(
                color: Colors.cyan,
                shape: RadialNeedleShape.tapperedLine,
                alignment: RadialElementAlignment.end,
                thickness: 12,
                topOffest: -20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
